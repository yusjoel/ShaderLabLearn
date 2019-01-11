using UnityEngine;

[ExecuteInEditMode]
public class OldFilm : MonoBehaviour
{
    public Material Material;

    public Texture VignetteTex;

    public Texture ScratchesTex;

    public Texture DustTex;

    public Color SepiaColor;

    [Range(0, 1)]
    public float VignetteAmount = 0.5f;

    public float ScratchesXSpeed = 10;

    public float ScratchesYSpeed = 10;

    public float DustXSpeed = 10;

    public float DustYSpeed = 10;

    [Range(0, 1.5f)]
    public float EffectAmount = 1f;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (VignetteTex)
            Material.SetTexture("_VignetteTex", VignetteTex);
        if (ScratchesTex)
            Material.SetTexture("_ScratchesTex", ScratchesTex);
        if (DustTex)
            Material.SetTexture("_DustTex", DustTex);
        Material.SetColor("_SepiaColor", SepiaColor);
        Material.SetFloat("_VignetteAmount", VignetteAmount);
        Material.SetFloat("_ScratchesXSpeed", ScratchesXSpeed);
        Material.SetFloat("_ScratchesYSpeed", ScratchesYSpeed);
        Material.SetFloat("_DustXSpeed", DustXSpeed);
        Material.SetFloat("_DustYSpeed", DustYSpeed);
        Material.SetFloat("_EffectAmount", EffectAmount);
        Material.SetFloat("_RandomValue", Random.Range(-1, 1));
        Graphics.Blit(source, destination, Material);
    }
}
