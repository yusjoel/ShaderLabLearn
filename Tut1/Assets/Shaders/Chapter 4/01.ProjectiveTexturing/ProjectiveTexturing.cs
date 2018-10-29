using UnityEngine;

[ExecuteInEditMode]
public class ProjectiveTexturing : MonoBehaviour
{
    public Renderer[] Renderers;

    public Texture2D ProjectedTexture;

    public Transform ProjectorTarget;

    public float Scale;

    public Camera Camera;

    private void Update()
    {
        if (Renderers == null || ProjectedTexture == null || ProjectorTarget == null || Camera == null)
            return;

#if false
        float halfWidth = ProjectedTexture.width / 2f;
        float halfHeight = ProjectedTexture.height / 2f;

        // Calculate an orthographic projection matrix for the
        // projector "camera"
        var projectionMatrix = Matrix4x4.Ortho(
            -halfWidth * Scale, halfWidth * Scale,
            -halfHeight * Scale, halfHeight * Scale,
            0.3f, 5000);
        if (SystemInfo.usesReversedZBuffer)
        {
            projectionMatrix[2, 0] = -projectionMatrix[2, 0];
            projectionMatrix[2, 1] = -projectionMatrix[2, 1];
            projectionMatrix[2, 2] = -projectionMatrix[2, 2];
            projectionMatrix[2, 3] = -projectionMatrix[2, 3];
        }
        //projectionMatrix = GL.GetGPUProjectionMatrix(projectionMatrix, true);

        // Calculate view matrix as usual
        var viewMatrix = Matrix4x4.LookAt(Camera.transform.position,
            ProjectorTarget.position, Vector3.back);
        //var viewMatrix = Matrix4x4.TRS(-Camera.transform.position, Camera.transform.rotation, Vector3.one);
#else
        // 先将摄像机当成投影仪， 使用摄像机的VP矩阵
        var viewMatrix = Camera.worldToCameraMatrix;
        var projectionMatrix = GL.GetGPUProjectionMatrix(Camera.projectionMatrix, true);
#endif
        foreach (var r in Renderers)
        {
            var material = r.sharedMaterial;
            material.SetTexture("_ProjectedTexture", ProjectedTexture);
            material.SetMatrix("_ProjectorViewProjection", projectionMatrix * viewMatrix);
        }
    }
}
