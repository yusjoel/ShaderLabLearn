using System.Collections;
using UnityEditor;

namespace Tools.Rendering.Editor
{
    public class EditorCoroutine
    {
        private readonly IEnumerator routine;

        private EditorCoroutine(IEnumerator routine)
        {
            this.routine = routine;
        }

        public static EditorCoroutine Start(IEnumerator routine)
        {
            var coroutine = new EditorCoroutine(routine);
            coroutine.Start();
            return coroutine;
        }

        private void Start()
        {
            //Debug.Log("Start");
            EditorApplication.update += Update;
        }

        public void Stop()
        {
            //Debug.Log("Stop");
            // ReSharper disable once DelegateSubtraction
            EditorApplication.update -= Update;
        }

        private void Update()
        {
            /* NOTE: no need to try/catch MoveNext,
             * if an IEnumerator throws its next iteration returns false.
             * Also, Unity probably catches when calling EditorApplication.update.
             */

            //Debug.Log("Update");
            if (!routine.MoveNext()) Stop();
        }
    }
}
