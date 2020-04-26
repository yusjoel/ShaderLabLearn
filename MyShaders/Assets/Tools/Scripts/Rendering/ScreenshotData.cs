using System.Collections.Generic;
using UnityEngine;

namespace Tools.Rendering
{
    public class ScreenShotData : MonoBehaviour
    {
        public string Name;

        public string Description;

        public List<ScreenShotInfo> ScreenShotInfos = new List<ScreenShotInfo>();

        void OnGUI()
        {
            var rect = new Rect(50, 50, 600, 20);
            GUI.Label(rect, Name);
            rect.y += 25;
            GUI.Label(rect, Description);
        }
    }
}
