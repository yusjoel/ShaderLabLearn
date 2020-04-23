using Gempoll.Editor.Rendering;
using Gempoll.Plugins.Extensions;
using System.Collections;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

namespace Gempoll.Plugins.Rendering.Editor
{
    public class RenderingDebugTool
    {
        private const string MenuName = "Tools/Rendering Debug Tool";
        private static RenderingDebugTool instance;

        /// <summary>
        ///     是否开启拾取
        /// </summary>
        private bool enabled;

        private ScreenshotData cachedScreenshotData;

        private RenderingDebugTool()
        {
            // 这里处理菜单的勾选
            EditorApplication.delayCall += () =>
            {
                bool savedEnabled = EditorPrefs.GetBool(MenuName, false);
                PerformAction(savedEnabled);
            };
        }


        [InitializeOnLoadMethod]
        private static void Initialize()
        {
            // 编辑器载入时运行
            if (instance != null)
                return;

            instance = new RenderingDebugTool();

            // 注册OnSceneGUI
            SceneView.onSceneGUIDelegate += instance.OnScene;
        }

        private int screenshotIndex;

        /// <summary>
        ///     SceneView描绘
        /// </summary>
        /// <param name="sceneView"></param>
        private void OnScene(SceneView sceneView)
        {
            if (!enabled)
                return;

            var screenshotData = GetScreenshotData();
            if (screenshotData == null)
                return;

            Handles.BeginGUI();
            var rect = new Rect(10, 50, 150, 20);

            // 预览已保存镜头
            int screenshotInfosCount = screenshotData.ScreenshotInfos.Count;
            GUI.Label(rect, string.Format("截屏: {0:D2} / {1:D2}", screenshotIndex, screenshotInfosCount));
            rect.y += 20;

            int newScreenshotIndex = (int)GUI.HorizontalSlider(rect, screenshotIndex, 0, screenshotInfosCount);
            if (newScreenshotIndex != screenshotIndex)
            {
                screenshotIndex = newScreenshotIndex;
                Show(screenshotData.ScreenshotInfos[screenshotIndex]);
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

                var screenshotInfo = new ScreenshotInfo
                {
                    CameraPosition = mainCamera.transform.position,
                    CameraEulerAngles = mainCamera.transform.eulerAngles,
                    CameraFieldOfView = mainCamera.fieldOfView,
                    CameraNearClipPlane = mainCamera.nearClipPlane,
                    CameraFarClipPlane = mainCamera.farClipPlane,
                    Renderers = renderers.Where(renderer => renderer.enabled).ToList()
                };

                var material = screenshotInfo.Renderers[0].sharedMaterial;
                var materialName = material.name;
                var shaderName = material.shader.name;

                var canvas = GameObject.Find("Canvas");
                var shaderNameText = canvas.FindComponent<Text>("ShaderName");
                shaderNameText.text = shaderName;
                var materialNameText = canvas.FindComponent<Text>("MaterialName");
                materialNameText.text = materialName;

                screenshotData.ScreenshotInfos.Add(screenshotInfo);
                string directory = string.Format("Screenshot/{0}/{1}",
                    EditorUserBuildSettings.activeBuildTarget,
                    screenshotData.Name);
                if (!Directory.Exists(directory))
                    Directory.CreateDirectory(directory);

                string path = Path.Combine(directory, string.Format("screenshot_{0:D3}.png", screenshotData.ScreenshotInfos.Count));
                ScreenCapture.CaptureScreenshot(path);
            }

            rect.y += 25;

            if (GUI.Button(rect, "重拍所有"))
            {
                EditorCoroutine.start(RecaptureAll());
            }

            rect.y += 25;

            if (GUI.Button(rect, "打开Frame Debugger"))
            {
                EditorApplication.ExecuteMenuItem("Window/Frame Debugger");
            }

            rect.y += 25;

            if (GUI.Button(rect, "打开Lighting Settings"))
            {
                EditorApplication.ExecuteMenuItem("Window/Lighting/Settings");
            }

            Handles.EndGUI();
        }

        private void Show(ScreenshotInfo screenshotInfo)
        {
            var sceneViewCamera = SceneView.currentDrawingSceneView.camera;
            var mainCameraObj = GameObject.Find("Main Camera");
            var mainCamera = mainCameraObj.GetComponent<Camera>();
            var renderers = Object.FindObjectsOfType<Renderer>();

            // 只显示选中部分
            foreach (var renderer in renderers)
                renderer.enabled = screenshotInfo.Renderers.Contains(renderer);

            // 设置SceneView镜头
            sceneViewCamera.transform.position = screenshotInfo.CameraPosition;
            sceneViewCamera.transform.eulerAngles = screenshotInfo.CameraEulerAngles;

            // 设置GameView镜头
            mainCameraObj.transform.position = screenshotInfo.CameraPosition;
            mainCameraObj.transform.eulerAngles = screenshotInfo.CameraEulerAngles;
            mainCamera.fieldOfView = screenshotInfo.CameraFieldOfView;
            mainCamera.nearClipPlane = screenshotInfo.CameraNearClipPlane;
            mainCamera.farClipPlane = screenshotInfo.CameraFarClipPlane;

            // 写入Shader/Material信息
            var material = screenshotInfo.Renderers[0].sharedMaterial;
            var materialName = material.name;
            var shaderName = material.shader.name;

            var canvas = GameObject.Find("Canvas");
            var shaderNameText = canvas.FindComponent<Text>("ShaderName");
            shaderNameText.text = shaderName;
            var materialNameText = canvas.FindComponent<Text>("MaterialName");
            materialNameText.text = materialName;
        }

        private ScreenshotData GetScreenshotData()
        {
            if (cachedScreenshotData)
                return cachedScreenshotData;
            cachedScreenshotData = Object.FindObjectOfType<ScreenshotData>();
            return cachedScreenshotData;
        }

        private IEnumerator RecaptureAll()
        {
            var mainCameraObj = GameObject.Find("Main Camera");
            var mainCamera = mainCameraObj.GetComponent<Camera>();
            var screenshotData = GetScreenshotData();
            var renderers = Object.FindObjectsOfType<Renderer>();

            int count = screenshotData.ScreenshotInfos.Count;
            for (int i = 0; i < count; i++)
            {
                EditorUtility.DisplayProgressBar("重拍所有", string.Format("{0}/{1}", i, count), (float)i / count);
                var screenshotInfo = screenshotData.ScreenshotInfos[i];

                // 只显示选中部分
                foreach (var renderer in renderers)
                    renderer.enabled = screenshotInfo.Renderers.Contains(renderer);

                // 位置与旋转
                mainCameraObj.transform.position = screenshotInfo.CameraPosition;
                mainCameraObj.transform.eulerAngles = screenshotInfo.CameraEulerAngles;

                // 参数
                mainCamera.fieldOfView = screenshotInfo.CameraFieldOfView;
                mainCamera.nearClipPlane = screenshotInfo.CameraNearClipPlane;
                mainCamera.farClipPlane = screenshotInfo.CameraFarClipPlane;

                // 写入Shader/Material信息
                var material = screenshotInfo.Renderers[0].sharedMaterial;
                var materialName = material.name;
                var shaderName = material.shader.name;

                var canvas = GameObject.Find("Canvas");
                var shaderNameText = canvas.FindComponent<Text>("ShaderName");
                shaderNameText.text = shaderName;
                var materialNameText = canvas.FindComponent<Text>("MaterialName");
                materialNameText.text = materialName;

                // 截屏
                string directory = string.Format("Screenshot/{0}/{1}",
                    EditorUserBuildSettings.activeBuildTarget,
                    screenshotData.Name);
                if (!Directory.Exists(directory))
                    Directory.CreateDirectory(directory);

                string path = Path.Combine(directory, string.Format("screenshot_{0:D3}.png", i + 1));
                ScreenCapture.CaptureScreenshot(path);

                yield return null;
            }
            EditorUtility.ClearProgressBar();
        }


        [MenuItem(MenuName)]
        private static void ToggleAction()
        {
            PerformAction(!instance.enabled);
        }

        private static void PerformAction(bool enabled)
        {
            Menu.SetChecked(MenuName, enabled);
            EditorPrefs.SetBool(MenuName, enabled);
            instance.enabled = enabled;
        }
    }
}
