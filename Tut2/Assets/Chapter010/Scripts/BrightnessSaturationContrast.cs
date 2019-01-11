using UnityEngine;

[ExecuteInEditMode]
public class BrightnessSaturationContrast : MonoBehaviour
{
    public Material Material;

    [Range(0, 2)]
    public float BrightnessAmount = 0.5f;

    [Range(0, 2)]
    public float SaturationAmount = 0.5f;

    [Range(0, 3)]
    public float ContrastAmount = 0.5f;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Material.SetFloat("_BrightnessAmount", BrightnessAmount);
        Material.SetFloat("_SaturationAmount", SaturationAmount);
        Material.SetFloat("_ContrastAmount", ContrastAmount);
        Graphics.Blit(source, destination, Material);
    }
}
