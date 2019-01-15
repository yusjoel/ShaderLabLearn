using UnityEngine;

[ExecuteInEditMode]
public class SceneDepth : MonoBehaviour
{
    public Material Material;

    [Range(0, 5)]
    public float DepthPower = 1;

    private void OnEnable()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Material.SetFloat("_DepthPower", DepthPower);
        Graphics.Blit(source, destination, Material);
    }
}
