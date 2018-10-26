using UnityEngine;

[ExecuteInEditMode]
public class ProjectiveTexturing : MonoBehaviour
{
    //public Material[] Materials;
    public Renderer[] Renderers;

    public Texture2D ProjectedTexture;

    public Transform ProjectorTarget;

    public float Scale;

    private void Update()
    {
        float halfWidth = Screen.width / 2;
        float halfHeight = Screen.height / 2;

        // Calculate an orthographic projection matrix for the
        // projector "camera"
        var projection = Matrix4x4.Ortho(
            -halfWidth * Scale, halfWidth * Scale,
            -halfHeight * Scale, halfHeight * Scale,
            -100000, 100000);

        // Calculate view matrix as usual
        var view = Matrix4x4.LookAt(transform.position,
            ProjectorTarget.position, Vector3.up);

        foreach (var r in Renderers)
        {
            var material = r.sharedMaterial;
            material.SetTexture("_ProjectedTexture", ProjectedTexture);
            material.SetMatrix("ProjectorViewProjection", view * projection);
        }
    }
}
