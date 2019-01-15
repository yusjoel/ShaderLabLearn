using UnityEngine;

[ExecuteInEditMode]
public class NightVision : MonoBehaviour
{
    public Material Material;

    public Texture VignetteTex;

    public Texture ScanLineTex;

    public Texture NoiseTex;

    public Color NightVisionColor;

    [Range(0, 4)]
    public float Contrast = 2;

    public float ScanLineTileAmount = 4;

    [Range(0, 2)]
    public float Brightnes = 1;

    public float NoiseXSpeed = 100;

    public float NoiseYSpeed = 100;

    [Range(-1, 1)]
    public float Distortion = 0.2f;

    [Range(0, 3)]
    public float Scale = 0.8f;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (VignetteTex)
            Material.SetTexture("_VignetteTex", VignetteTex);
        if (ScanLineTex)
            Material.SetTexture("_ScanLineTex", ScanLineTex);
        if (NoiseTex)
            Material.SetTexture("_NoiseTex", NoiseTex);
        Material.SetColor("_NightVisionColor", NightVisionColor);
        Material.SetFloat("_Contrast", Contrast);
        Material.SetFloat("_ScanLineTileAmount", ScanLineTileAmount);
        Material.SetFloat("_Brightnes", Brightnes);
        Material.SetFloat("_NoiseXSpeed", NoiseXSpeed);
        Material.SetFloat("_NoiseYSpeed", NoiseYSpeed);
        Material.SetFloat("_Distortion", Distortion);
        Material.SetFloat("_Scale", Scale);
        Material.SetFloat("_RandomValue", Random.Range(-1, 1));
        Graphics.Blit(source, destination, Material);
    }
}
