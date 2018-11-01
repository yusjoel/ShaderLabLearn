using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class DepthOfField : MonoBehaviour {

    public Material GaussianBlur;

    public Material Material;

    public float BlurAmount = 2;

    float[] weightsH, weightsV;
    Vector4[] offsetsH, offsetsV;

    private void Start()
    {
        // Calculate weights/offsets for horizontal pass
        calcSettings(1.0f / Screen.width, 0, out weightsH, out offsetsH);
        // Calculate weights/offsets for vertical pass
        calcSettings(0, 1.0f / Screen.height, out weightsV, out offsetsV);

        var c = GetComponent<Camera>();
        c.depthTextureMode = DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (GaussianBlur != null && Material != null)
        {
            int w = source.width;
            int h = source.height;
            var buffer = RenderTexture.GetTemporary(w, h, 0);
            var blurredTexture = RenderTexture.GetTemporary(w, h, 0);

            GaussianBlur.SetVectorArray("Offsets", offsetsH);
            GaussianBlur.SetFloatArray("Weights", weightsH);
            Graphics.Blit(source, buffer, GaussianBlur);

            GaussianBlur.SetVectorArray("Offsets", offsetsV);
            GaussianBlur.SetFloatArray("Weights", weightsV);
            Graphics.Blit(buffer, blurredTexture, GaussianBlur);

            Material.SetTexture("_BlurredTexture", blurredTexture);
            Graphics.Blit(source, destination, Material);

            RenderTexture.ReleaseTemporary(buffer);
            RenderTexture.ReleaseTemporary(blurredTexture);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    float gaussianFn(float x)
    {
        return (1.0f / Mathf.Sqrt(2 * Mathf.PI * BlurAmount * BlurAmount)) * Mathf.Exp(-(x * x) / (2 * BlurAmount * BlurAmount));
    }

    void calcSettings(float w, float h, out float[] weights, out Vector4[] offsets)
    {
        // 15 Samples
        weights = new float[15];
        offsets = new Vector4[15];
        // Calculate values for center pixel
        weights[0] = gaussianFn(0);
        offsets[0] = new Vector4(0, 0);
        float total = weights[0];
        // Calculate samples in pairs
        for (int i = 0; i < 7; i++)
        {
            // Weight each pair of samples according to Gaussian function
            float weight = gaussianFn(i + 1);
            weights[i * 2 + 1] = weight;
            weights[i * 2 + 2] = weight;
            total += weight * 2;
            // Samples are offset by 1.5 pixels, to make use of
            // filtering halfway between pixels
            float offset = i * 2 + 1.5f;
            Vector2 offsetVec = new Vector2(w, h) * offset;
            offsets[i * 2 + 1] = offsetVec;
            offsets[i * 2 + 2] = -offsetVec;
        }
        // Divide all weights by total so they will add up to 1
        for (int i = 0; i < weights.Length; i++)
            weights[i] /= total;
    }
}
