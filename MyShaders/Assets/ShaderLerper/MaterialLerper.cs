using UnityEngine;

/// <summary>
///     材质差值器
/// </summary>
public class MaterialLerper : MonoBehaviour
{
    /// <summary>
    ///     Color类型的属性
    /// </summary>
    public string[] ColorProperties;

    /// <summary>
    ///     Shader参数, 延迟
    /// </summary>
    public float Delay = 0.2f;

    /// <summary>
    ///     一个预估的结束时间
    ///     理论上变化时间 = 距离原点最远的点到原点的距离 / 速度 + 延迟
    /// </summary>
    public float Duration = 5f;

    /// <summary>
    ///     Float类型的属性
    /// </summary>
    public string[] FloatProperties;

    /// <summary>
    ///     进行差值的材质, 使用了特殊修改的着色器
    ///     在运行时会另外创建一个实例
    /// </summary>
    public Material Lerper;

    /// <summary>
    ///     Shader参数, 原点
    /// </summary>
    public Transform Origin;

    /// <summary>
    ///     需要进行变化材质的描绘器
    /// </summary>
    public Renderer[] Renderers;

    /// <summary>
    ///     Texture(2D/Cube)类型的属性
    /// </summary>
    public string[] TextureProperties;

    /// <summary>
    ///     Shader参数, 速度
    /// </summary>
    public float Speed = 5;

    /// <summary>
    ///     目标材质
    /// </summary>
    private Material endMaterial;

    /// <summary>
    ///     进行差值的材质实例, 使用了特殊修改的着色器
    /// </summary>
    private Material instanceLerper;

    /// <summary>
    ///     控制参数的更新
    /// </summary>
    private bool isPlaying;

    /// <summary>
    ///     起始材质
    /// </summary>
    private Material startMaterial;

    /// <summary>
    ///     Shader参数, 经过的时间
    /// </summary>
    private float time;

    /// <summary>
    ///     设置Color类型属性的起始值和结束值
    /// </summary>
    /// <param name="propertyName"></param>
    private void SetColor(string propertyName)
    {
        var startColor = startMaterial.GetColor(propertyName);
        var endColor = endMaterial.GetColor(propertyName);

        instanceLerper.SetColor(propertyName, startColor);
        instanceLerper.SetColor(propertyName + "LerpTo", endColor);
    }

    /// <summary>
    ///     设置Float类型属性的起始值和结束值
    /// </summary>
    /// <param name="propertyName"></param>
    private void SetFloat(string propertyName)
    {
        float startColor = startMaterial.GetFloat(propertyName);
        float endColor = endMaterial.GetFloat(propertyName);

        instanceLerper.SetFloat(propertyName, startColor);
        instanceLerper.SetFloat(propertyName + "LerpTo", endColor);
    }

    /// <summary>
    ///     设置Texture类型属性
    /// </summary>
    /// <param name="propertyName"></param>
    private void SetTexture(string propertyName)
    {
        var texture = endMaterial.GetTexture(propertyName);
        instanceLerper.SetTexture(propertyName, texture);

        var textureOffset = endMaterial.GetTextureOffset(propertyName);
        instanceLerper.SetTextureOffset(propertyName, textureOffset);

        var textureScale = endMaterial.GetTextureScale(propertyName);
        instanceLerper.SetTextureScale(propertyName, textureScale);
    }

    /// <summary>
    ///     初始化
    /// </summary>
    private void Initialize()
    {
        if (Renderers == null || Renderers.Length == 0)
            return;

        if (endMaterial == null)
            endMaterial = Renderers[0].sharedMaterial;

        if (instanceLerper == null)
        {
            instanceLerper = new Material(Lerper);
            instanceLerper.SetVector("_WorldOrigin", Origin.position);
            instanceLerper.SetFloat("_LerpSpeed", Speed);
            instanceLerper.SetFloat("_LerpDelay", Delay);
        }
    }

    /// <summary>
    ///     变化到指定的材质
    /// </summary>
    /// <param name="targetMaterial"></param>
    public void Lerp(Material targetMaterial)
    {
        Initialize();

        startMaterial = endMaterial;
        endMaterial = targetMaterial;

        foreach (string property in ColorProperties)
            SetColor(property);

        foreach (string property in FloatProperties)
            SetFloat(property);

        foreach (string property in TextureProperties)
            SetTexture(property);

        foreach (var r in Renderers)
            r.sharedMaterial = instanceLerper;

        isPlaying = true;
        time = 0;
    }

    private void Update()
    {
        if (isPlaying)
        {
            time += Time.deltaTime;
            instanceLerper.SetFloat("_LerpTime", time);

            if (time > Duration)
            {
                isPlaying = false;
                foreach (var r in Renderers)
                    r.sharedMaterial = endMaterial;
            }
        }
    }
}
