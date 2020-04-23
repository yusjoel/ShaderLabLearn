﻿using System.Collections;
using UnityEditor;

namespace Gempoll.Plugins.Rendering.Editor
{
    public class EditorCoroutine
    {
        private readonly IEnumerator routine;

        private EditorCoroutine(IEnumerator _routine)
        {
            routine = _routine;
        }

        public static EditorCoroutine start(IEnumerator _routine)
        {
            var coroutine = new EditorCoroutine(_routine);
            coroutine.start();
            return coroutine;
        }

        private void start()
        {
            //Debug.Log("start");
            EditorApplication.update += update;
        }

        public void stop()
        {
            //Debug.Log("stop");
            EditorApplication.update -= update;
        }

        private void update()
        {
            /* NOTE: no need to try/catch MoveNext,
             * if an IEnumerator throws its next iteration returns false.
             * Also, Unity probably catches when calling EditorApplication.update.
             */

            //Debug.Log("update");
            if (!routine.MoveNext()) stop();
        }
    }
}
