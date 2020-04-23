using Gempoll.Editor.Rendering;
using System.Collections.Generic;
using UnityEngine;

namespace Gempoll.Plugins.Rendering
{
    public class ScreenshotData : MonoBehaviour
    {
        public string Name;

        public string Description;

        public List<ScreenshotInfo> ScreenshotInfos = new List<ScreenshotInfo>();

        void OnGUI()
        {
            var rect = new Rect(50, 50, 600, 20);
            GUI.Label(rect, Name);
            rect.y += 25;
            GUI.Label(rect, Description);
        }
    }
}
