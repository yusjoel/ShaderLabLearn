using UnityEngine;

[ExecuteInEditMode]
public class SetReflectionMatrix : MonoBehaviour
{
    public Camera Camera;

    public Renderer Target;

    private void Update()
    {
        if (Camera == null || Target == null)
            return;

        var modelMatrix = Target.transform.localToWorldMatrix;
        var viewMatrix = Camera.worldToCameraMatrix;
        var projectionMatrix = GL.GetGPUProjectionMatrix(Camera.projectionMatrix, true);

        Target.sharedMaterial.SetMatrix("_ReflectedMvpMatrix", projectionMatrix * viewMatrix * modelMatrix);
    }
}