using UnityEngine;

[RequireComponent(typeof(Renderer))]
public class ProceduralTexture : MonoBehaviour
{
    public Texture2D GeneratedTexture;

    void Start()
    {
        var r = GetComponent<Renderer>();
        var material = r.sharedMaterial;
        if (material)
        {
            GeneratedTexture = GenerateParabola();
            material.SetTexture("_MainTex", GeneratedTexture);
        }
    }

    private Texture2D GenerateParabola()
    {
        var texture = new Texture2D(512, 512);
        var center = new Vector2(0.5f, 0.5f) * 512;
        for (int i = 0; i < 512; i++)
        {
            for (int j = 0; j < 512; j++)
            {
                var position = new Vector2(i, j);
                float distance = Vector2.Distance(position, center);
                float normalizedDistance = Mathf.Clamp01(distance / (512 * 0.5f));
                float colorValue = 1 - normalizedDistance;
                var color = new Color(colorValue, colorValue, colorValue, 1);
                texture.SetPixel(i, j, color);
            }
        }
        texture.Apply();
        return texture;
    }
}
