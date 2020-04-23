using UnityEngine;

[ExecuteInEditMode]
public class SetMatrix : MonoBehaviour
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

        Target.sharedMaterial.SetMatrix("_ModelMatrix", modelMatrix);
        Target.sharedMaterial.SetMatrix("_ViewMatrix", viewMatrix);
        Target.sharedMaterial.SetMatrix("_ProjectionMatrix", projectionMatrix);
    }
}