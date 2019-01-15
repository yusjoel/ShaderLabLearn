using UnityEngine;

[ExecuteInEditMode]
public class BlendMode : MonoBehaviour
{
    public Material Material;

    public Texture BlendTexture;

    [Range(0, 1)]
    public float BlendOpacity = 0.5f;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Material.SetTexture("_BlendTex", BlendTexture);
        Material.SetFloat("_Opacity", BlendOpacity);
        Graphics.Blit(source, destination, Material);
    }
}
