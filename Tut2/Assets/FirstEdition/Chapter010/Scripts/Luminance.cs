using UnityEngine;

[ExecuteInEditMode]
public class Luminance : MonoBehaviour
{
    public Material Material;

    [Range(0, 1)]
    public float GrayScaleAmount = 0.5f;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Material.SetFloat("_LuminosityAmount", GrayScaleAmount);
        Graphics.Blit(source, destination, Material);
    }
}
