using Extensions;
using System.Collections;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace Tools.Rendering.Editor
{
    public class RenderingDebugTool
    {
        private const string menuName = "Tools/Rendering Debug Tool";

        private static RenderingDebugTool instance;

        private ScreenShotData cachedScreenShotData;

        /// <summary>
        ///     是否开启拾取
        /// </summary>
        private bool enabled;

        private int screenShotIndex;

        private RenderingDebugTool()
        {
            // 这里处理菜单的勾选
            EditorApplication.delayCall += () =>
            {
                bool savedEnabled = EditorPrefs.GetBool(menuName, false);
                PerformAction(savedEnabled);
            };
        }

        [InitializeOnLoadMethod]
        public static void Initialize()
        {
            // 编辑器载入时运行
            if (instance != null)
                return;

            instance = new RenderingDebugTool();

            // 注册OnSceneGUI
            SceneView.duringSceneGui += instance.OnScene;
        }

        /// <summary>
        ///     SceneView描绘
        /// </summary>
        /// <param name="sceneView"></param>
        private void OnScene(SceneView sceneView)
        {
            if (!enabled)
                return;

            var screenShotData = GetScreenShotData();
            if (screenShotData == null)
                return;

            Handles.BeginGUI();
            var rect = new Rect(10, 50, 150, 20);

            // 预览已保存镜头
            int screenShotInfosCount = screenShotData.ScreenShotInfos.Count;
            GUI.Label(rect, $"截屏: {screenShotIndex:D2} / {screenShotInfosCount:D2}");
            rect.y += 20;

            int newScreenShotIndex = (int) GUI.HorizontalSlider(rect, screenShotIndex, 0, screenShotInfosCount);
            if (newScreenShotIndex != screenShotIndex)
            {
                screenShotIndex = newScreenShotIndex;
                Show(screenShotData.ScreenShotInfos[screenShotIndex]);
            }

            rect.y += 25;

            if (GUI.Button(rect, "同步镜头"))
            {
                if (Selection.gameObjects.IsNullOrEmpty())
                    return;

                // 只显示选中部分
                var renderers = Object.FindObjectsOfType<Renderer>();
                foreach (var renderer in renderers)
                    renderer.enabled = Selection.gameObjects.Contains(renderer.gameObject);

                // 获取SceneView的镜头, 应用到GameView中
                var sceneViewCamera = SceneView.currentDrawingSceneView.camera;
                var mainCameraObj = GameObject.Find("Main Camera");
                var mainCamera = mainCameraObj.GetComponent<Camera>();

                // 位置与旋转
                mainCameraObj.transform.position = sceneViewCamera.transform.position;
                mainCameraObj.transform.eulerAngles = sceneViewCamera.transform.eulerAngles;

                // 参数
                mainCamera.fieldOfView = sceneViewCamera.fieldOfView;
                mainCamera.nearClipPlane = sceneViewCamera.nearClipPlane;
                mainCamera.farClipPlane = sceneViewCamera.farClipPlane;
            }

            rect.y += 25;

            if (GUI.Button(rect, "截屏并保存"))
            {
                var mainCameraObj = GameObject.Find("Main Camera");
                var mainCamera = mainCameraObj.GetComponent<Camera>();
                var renderers = Object.FindObjectsOfType<Renderer>();

                var screenShotInfo = new ScreenShotInfo
                {
                    CameraPosition = mainCamera.transform.position,
                    CameraEulerAngles = mainCamera.transform.eulerAngles,
                    CameraFieldOfView = mainCamera.fieldOfView,
                    CameraNearClipPlane = mainCamera.nearClipPlane,
                    CameraFarClipPlane = mainCamera.farClipPlane,
                    Renderers = renderers.Where(renderer => renderer.enabled).ToList()
                };

                var material = screenShotInfo.Renderers[0].sharedMaterial;
                string materialName = material.name;
                string shaderName = material.shader.name;

                var canvas = GameObject.Find("Canvas");
                var shaderNameText = canvas.FindComponent<Text>("ShaderName");
                shaderNameText.text = shaderName;
                var materialNameText = canvas.FindComponent<Text>("MaterialName");
                materialNameText.text = materialName;

                screenShotData.ScreenShotInfos.Add(screenShotInfo);
                string directory = $"ScreenShot/{EditorUserBuildSettings.activeBuildTarget}/{screenShotData.Name}";
                if (!Directory.Exists(directory))
                    Directory.CreateDirectory(directory);

                string path = Path.Combine(directory,
                    $"screenShot_{screenShotData.ScreenShotInfos.Count:D3}.png");
                ScreenCapture.CaptureScreenshot(path);
            }

            rect.y += 25;

            if (GUI.Button(rect, "重拍所有")) EditorCoroutine.Start(RecaptureAll());

            rect.y += 25;

            if (GUI.Button(rect, "打开Frame Debugger")) EditorApplication.ExecuteMenuItem("Window/Frame Debugger");

            rect.y += 25;

            if (GUI.Button(rect, "打开Lighting Settings")) EditorApplication.ExecuteMenuItem("Window/Lighting/Settings");

            Handles.EndGUI();
        }

        private void Show(ScreenShotInfo screenShotInfo)
        {
            var sceneViewCamera = SceneView.currentDrawingSceneView.camera;
            var mainCameraObj = GameObject.Find("Main Camera");
            var mainCamera = mainCameraObj.GetComponent<Camera>();
            var renderers = Object.FindObjectsOfType<Renderer>();

            // 只显示选中部分
            foreach (var renderer in renderers)
                renderer.enabled = screenShotInfo.Renderers.Contains(renderer);

            // 设置SceneView镜头
            sceneViewCamera.transform.position = screenShotInfo.CameraPosition;
            sceneViewCamera.transform.eulerAngles = screenShotInfo.CameraEulerAngles;

            // 设置GameView镜头
            mainCameraObj.transform.position = screenShotInfo.CameraPosition;
            mainCameraObj.transform.eulerAngles = screenShotInfo.CameraEulerAngles;
            mainCamera.fieldOfView = screenShotInfo.CameraFieldOfView;
            mainCamera.nearClipPlane = screenShotInfo.CameraNearClipPlane;
            mainCamera.farClipPlane = screenShotInfo.CameraFarClipPlane;

            // 写入Shader/Material信息
            var material = screenShotInfo.Renderers[0].sharedMaterial;
            string materialName = material.name;
            string shaderName = material.shader.name;

            var canvas = GameObject.Find("Canvas");
            var shaderNameText = canvas.FindComponent<Text>("ShaderName");
            shaderNameText.text = shaderName;
            var materialNameText = canvas.FindComponent<Text>("MaterialName");
            materialNameText.text = materialName;
        }

        private ScreenShotData GetScreenShotData()
        {
            if (cachedScreenShotData)
                return cachedScreenShotData;

            cachedScreenShotData = Object.FindObjectOfType<ScreenShotData>();
            return cachedScreenShotData;
        }

        private IEnumerator RecaptureAll()
        {
            var mainCameraObj = GameObject.Find("Main Camera");
            var mainCamera = mainCameraObj.GetComponent<Camera>();
            var screenShotData = GetScreenShotData();
            var renderers = Object.FindObjectsOfType<Renderer>();

            int count = screenShotData.ScreenShotInfos.Count;
            for (int i = 0; i < count; i++)
            {
                EditorUtility.DisplayProgressBar("重拍所有", $"{i}/{count}", (float) i / count);
                var screenShotInfo = screenShotData.ScreenShotInfos[i];

                // 只显示选中部分
                foreach (var renderer in renderers)
                    renderer.enabled = screenShotInfo.Renderers.Contains(renderer);

                // 位置与旋转
                mainCameraObj.transform.position = screenShotInfo.CameraPosition;
                mainCameraObj.transform.eulerAngles = screenShotInfo.CameraEulerAngles;

                // 参数
                mainCamera.fieldOfView = screenShotInfo.CameraFieldOfView;
                mainCamera.nearClipPlane = screenShotInfo.CameraNearClipPlane;
                mainCamera.farClipPlane = screenShotInfo.CameraFarClipPlane;

                // 写入Shader/Material信息
                var material = screenShotInfo.Renderers[0].sharedMaterial;
                string materialName = material.name;
                string shaderName = material.shader.name;

                var canvas = GameObject.Find("Canvas");
                var shaderNameText = canvas.FindComponent<Text>("ShaderName");
                shaderNameText.text = shaderName;
                var materialNameText = canvas.FindComponent<Text>("MaterialName");
                materialNameText.text = materialName;

                // 截屏
                string directory = $"ScreenShot/{EditorUserBuildSettings.activeBuildTarget}/{screenShotData.Name}";
                if (!Directory.Exists(directory))
                    Directory.CreateDirectory(directory);

                string path = Path.Combine(directory, $"screenShot_{i + 1:D3}.png");
                ScreenCapture.CaptureScreenshot(path);

                yield return null;
            }
            EditorUtility.ClearProgressBar();
        }

        [MenuItem(menuName)]
        public static void ToggleAction()
        {
            PerformAction(!instance.enabled);
        }

        private static void PerformAction(bool enabled)
        {
            Menu.SetChecked(menuName, enabled);
            EditorPrefs.SetBool(menuName, enabled);
            instance.enabled = enabled;
        }
    }
}
