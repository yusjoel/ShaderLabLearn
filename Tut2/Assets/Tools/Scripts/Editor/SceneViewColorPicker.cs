using System;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace Tools.Editor
{
    /// <summary>
    ///     SceneView下的颜色拾取器
    ///     参考了《Unity Shader入门精要》一书的ColorPicker.cs
    /// </summary>
    public class SceneViewColorPicker
    {
        private const string MenuName = "Tools/Color Picker";
        private static SceneViewColorPicker instance;

        /// <summary>
        ///     缓存的UI风格, 用来放bg
        /// </summary>
        private GUIStyle boxStyle;

        /// <summary>
        ///     显示出来的纯色贴图
        /// </summary>
        private Texture2D colorTexture;

        /// <summary>
        ///     是否连续拾取, 开启后会卡一些
        /// </summary>
        private bool continuouslyPick;

        /// <summary>
        ///     是否开启拾取
        /// </summary>
        private bool enabled;

        /// <summary>
        ///     拾取的颜色
        /// </summary>
        private Color pickedColor = Color.white;

        /// <summary>
        ///     拾取位置X
        /// </summary>
        private int pickedX;

        /// <summary>
        ///     拾取位置Y
        /// </summary>
        private int pickedY;

        /// <summary>
        ///     拾取范围贴图
        /// </summary>
        private Texture2D pickTexture;

        /// <summary>
        ///     SceneView截屏贴图
        /// </summary>
        private Texture2D screenshotTexture;

        private SceneViewColorPicker()
        {
            // 这里处理菜单的勾选
            // https://answers.unity.com/questions/775869/editor-how-to-add-checkmarks-to-menuitems.html
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

            instance = new SceneViewColorPicker();

            // 注册OnSceneGUI
            // https://answers.unity.com/questions/768175/add-gui-elements-to-scene-view.html
            SceneView.onSceneGUIDelegate += instance.OnScene;
        }

        [MenuItem(MenuName)]
        private static void ToggleAction()
        {
            // 菜单点击后开启/关闭拾色器
            PerformAction(!instance.enabled);
        }

        private static void PerformAction(bool enabled)
        {
            Menu.SetChecked(MenuName, enabled);
            EditorPrefs.SetBool(MenuName, enabled);
            instance.enabled = enabled;
        }

        /// <summary>
        ///     测试如何获取SceneView的截屏
        /// </summary>
        /// <param name="sceneView"></param>
        /// <param name="mousePosition"></param>
        public void TryCaptureScreenshot(SceneView sceneView, Vector2 mousePosition)
        {
            // https://forum.unity.com/threads/mouse-position-in-scene-view.250399/#post-3760579
            // https://answers.unity.com/questions/63361/how-to-find-out-the-real-viewportscreen-size-in-sc.html

            int sceneViewWidth = (int) sceneView.position.width;
            int sceneViewHeight = (int) sceneView.position.height;
            var style = (GUIStyle) "GV Gizmo DropDown";
            var ribbon = style.CalcSize(sceneView.titleContent);

            var cameraPixelRect = sceneView.camera.pixelRect;
            int viewportWidth = (int) cameraPixelRect.width;
            int viewportHeight = (int) cameraPixelRect.height;

            Debug.LogFormat("view: {0}, camera: {1}, ribbon: {2}, mouse: {3}",
                sceneView.position, cameraPixelRect, ribbon, mousePosition);

            // 获取的截图包含头部(titleContent), 可以通过计算高度来去除
            Capture(sceneViewWidth, sceneViewHeight, "d:\\SceneView.png");
            // 获取的截图不包含头部, 但是和上面计算的值差一个像素
            Capture(viewportWidth, viewportHeight, "d:\\Viewport.png");
            // 只能获取GameView的截图
            Application.CaptureScreenshot("d:\\Screenshot.png");
        }

        /// <summary>
        ///     SceneView描绘
        /// </summary>
        /// <param name="sceneView"></param>
        private void OnScene(SceneView sceneView)
        {
            if (!enabled)
                return;

            var e = Event.current;
            if (continuouslyPick)
            {
                PickColor(sceneView, e.mousePosition);
            }
            else
            {
                if (e.type == EventType.mouseDown && e.button == 0)
                    PickColor(sceneView, e.mousePosition);
            }

            Handles.BeginGUI();
            GUI.Box(new Rect(0, 0, 220, 240), "Color Picker");
            DrawPickBox(new Vector2(20, 30), 40, 40);
            DrawColorBox(new Rect(120, 30, 81, 81));

            // 显示[0, 1]的RGBA
            GUI.Label(new Rect(10, 120, 100, 20),
                "R: " + Math.Round(pickedColor.r, 4) + "\t(" + Mathf.FloorToInt(pickedColor.r * 255) + ")");
            GUI.Label(new Rect(10, 140, 100, 20),
                "G: " + Math.Round(pickedColor.g, 4) + "\t(" + Mathf.FloorToInt(pickedColor.g * 255) + ")");
            GUI.Label(new Rect(10, 160, 100, 20),
                "B: " + Math.Round(pickedColor.b, 4) + "\t(" + Mathf.FloorToInt(pickedColor.b * 255) + ")");
            GUI.Label(new Rect(10, 180, 100, 20),
                "A: " + Math.Round(pickedColor.a, 4) + "\t(" + Mathf.FloorToInt(pickedColor.a * 255) + ")");

            // 转成[-1, 1]的XYZW
            GUI.Label(new Rect(130, 120, 100, 20), "X: " + Math.Round((pickedColor.r - 0.5f) * 2, 4));
            GUI.Label(new Rect(130, 140, 100, 20), "Y: " + Math.Round((pickedColor.g - 0.5f) * 2, 4));
            GUI.Label(new Rect(130, 160, 100, 20), "Z: " + Math.Round((pickedColor.b - 0.5f) * 2, 4));
            GUI.Label(new Rect(130, 180, 100, 20), "W: " + Math.Round((pickedColor.a - 0.5f) * 2, 4));

            continuouslyPick = GUI.Toggle(new Rect(10, 200, 200, 20), continuouslyPick, " 连续拾取? (会卡顿)");
            enabled = GUI.Toggle(new Rect(10, 220, 220, 20), enabled, " 开启 (菜单: " + MenuName + ")");
            if (!enabled)
                PerformAction(false);

            Handles.EndGUI();
        }

        /// <summary>
        ///     拾取鼠标位置的像素颜色, <see cref="TryCaptureScreenshot" />
        /// </summary>
        /// <param name="sceneView"></param>
        /// <param name="mousePosition"></param>
        private void PickColor(SceneView sceneView, Vector2 mousePosition)
        {
            var cameraPixelRect = sceneView.camera.pixelRect;
            int viewportWidth = (int) cameraPixelRect.width;
            int viewportHeight = (int) cameraPixelRect.height;

            Capture(viewportWidth, viewportHeight, null);

            // 鼠标位置的原点在左上角, 贴图在左下角
            pickedX = (int) mousePosition.x;
            pickedY = viewportHeight - (int) mousePosition.y;
            pickedColor = screenshotTexture.GetPixel(pickedX, pickedY);
        }

        /// <summary>
        ///     截屏
        /// </summary>
        /// <param name="sceneViewWidth"></param>
        /// <param name="sceneViewHeight"></param>
        /// <param name="filename"></param>
        private void Capture(int sceneViewWidth, int sceneViewHeight, string filename)
        {
            // 截取当前RenderTarget
            screenshotTexture = new Texture2D(sceneViewWidth, sceneViewHeight);
            screenshotTexture.ReadPixels(new Rect(0, 0, sceneViewWidth, sceneViewHeight), 0, 0);
            screenshotTexture.Apply();

            if (!string.IsNullOrEmpty(filename))
            {
                var bytes = screenshotTexture.EncodeToPNG();
                File.WriteAllBytes(filename, bytes);
            }
        }

        /// <summary>
        ///     显示拾取的纯色贴图
        /// </summary>
        /// <param name="rect"></param>
        private void DrawColorBox(Rect rect)
        {
            if (colorTexture == null)
                colorTexture = new Texture2D(1, 1);

            if (boxStyle == null)
                boxStyle = new GUIStyle();

            colorTexture.SetPixel(0, 0, pickedColor);
            colorTexture.Apply();
            boxStyle.normal.background = colorTexture;
            GUI.Box(rect, GUIContent.none, boxStyle);
        }

        /// <summary>
        ///     显示拾取范围贴图
        /// </summary>
        /// <param name="position"></param>
        /// <param name="halfWidth"></param>
        /// <param name="halfHeight"></param>
        private void DrawPickBox(Vector2 position, int halfWidth, int halfHeight)
        {
            int width = halfWidth * 2 + 1;
            int height = halfHeight * 2 + 1;

            if (pickTexture == null)
                pickTexture = new Texture2D(width, height);

            if (boxStyle == null)
                boxStyle = new GUIStyle();

            for (int i = 0; i < width; i++)
            for (int j = 0; j < height; j++)
            {
                if (screenshotTexture == null)
                {
                    pickTexture.SetPixel(i, j, Color.black);
                    continue;
                }

                int x = i + pickedX - halfWidth;
                int y = j + pickedY - halfHeight;
                // 超出屏幕范围显示黑色
                bool outRange = x < 0 || x >= screenshotTexture.width || y < 0 || y >= screenshotTexture.height;
                var color = outRange ? Color.black : screenshotTexture.GetPixel(x, y);
                // 白色十字准星
                bool crosshair = i == halfWidth && Mathf.Abs(j - halfHeight) < 5 || j == halfHeight && Mathf.Abs(i - halfWidth) < 5;
                if (crosshair)
                    color = Color.white;

                pickTexture.SetPixel(i, j, color);
            }

            pickTexture.Apply();
            boxStyle.normal.background = pickTexture;
            GUI.Box(new Rect(position.x, position.y, width, height), GUIContent.none, boxStyle);
        }
    }
}
