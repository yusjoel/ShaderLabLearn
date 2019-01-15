using System;
using UnityEngine;

public enum TextureType
{
    Circle,

    Ring,

    DotProduct,

    Angle
}

[RequireComponent(typeof(Renderer))]
public class ProceduralTexture : MonoBehaviour
{
    public Texture2D GeneratedTexture;
    public TextureType TextureType;

    private void OnEnable()
    {
        var r = GetComponent<Renderer>();
        var material = r.sharedMaterial;
        if (material)
        {
            GeneratedTexture = GenerateTexture();
            material.SetTexture("_MainTex", GeneratedTexture);
        }
    }

    private Texture2D GenerateTexture()
    {
        if (TextureType == TextureType.Circle)
            return GenerateCircle();
        if (TextureType == TextureType.Ring)
            return GenerateRing();
        if (TextureType == TextureType.DotProduct)
            return GenerateDotProductMap();
        if (TextureType == TextureType.Angle)
            return GenerateAngleMap();
        throw new NotImplementedException();
    }

    /// <summary>
    ///     像素方向的点积图
    /// </summary>
    /// <returns></returns>
    private Texture2D GenerateDotProductMap()
    {
        var texture = new Texture2D(512, 512);
        var center = new Vector2(0.5f, 0.5f) * 512;
        for (int i = 0; i < 512; i++)
        for (int j = 0; j < 512; j++)
        {
            var position = new Vector2(i, j);
            var pixelDirection = position - center;
            pixelDirection.Normalize();
            float r = Vector2.Dot(pixelDirection, Vector2.right);
            float g = Vector2.Dot(pixelDirection, Vector2.up);
            var color = new Color(r, g, 0, 1);
            texture.SetPixel(i, j, color);
        }

        texture.Apply();
        return texture;
    }

    /// <summary>
    ///     像素方向的角度图
    /// </summary>
    /// <returns></returns>
    private Texture2D GenerateAngleMap()
    {
        var texture = new Texture2D(512, 512);
        var center = new Vector2(0.5f, 0.5f) * 512;
        for (int i = 0; i < 512; i++)
        for (int j = 0; j < 512; j++)
        {
            var position = new Vector2(i, j);
            var pixelDirection = position - center;
            pixelDirection.Normalize();
            float r = Vector2.Angle(pixelDirection, Vector2.right) / 360;
            float g = Vector2.Angle(pixelDirection, Vector2.up) / 360;
            var color = new Color(r, g, 0, 1);
            texture.SetPixel(i, j, color);
        }

        texture.Apply();
        return texture;
    }

    /// <summary>
    ///     渐变色的环
    /// </summary>
    /// <returns></returns>
    private Texture2D GenerateRing()
    {
        var texture = new Texture2D(512, 512);
        var center = new Vector2(0.5f, 0.5f) * 512;
        for (int i = 0; i < 512; i++)
        for (int j = 0; j < 512; j++)
        {
            var position = new Vector2(i, j);
            float distance = Vector2.Distance(position, center);
            float normalizedDistance = Mathf.Clamp01(distance / (512 * 0.5f));
            float colorValue = 1 - normalizedDistance;
            colorValue = Mathf.Sin(colorValue * 30) * colorValue;
            var color = new Color(colorValue, colorValue, colorValue, 1);
            texture.SetPixel(i, j, color);
        }

        texture.Apply();
        return texture;
    }

    /// <summary>
    ///     渐变色的圆
    /// </summary>
    /// <returns></returns>
    private Texture2D GenerateCircle()
    {
        var texture = new Texture2D(512, 512);
        var center = new Vector2(0.5f, 0.5f) * 512;
        for (int i = 0; i < 512; i++)
        for (int j = 0; j < 512; j++)
        {
            var position = new Vector2(i, j);
            float distance = Vector2.Distance(position, center);
            float normalizedDistance = Mathf.Clamp01(distance / (512 * 0.5f));
            float colorValue = 1 - normalizedDistance;
            var color = new Color(colorValue, colorValue, colorValue, 1);
            texture.SetPixel(i, j, color);
        }

        texture.Apply();
        return texture;
    }
}
