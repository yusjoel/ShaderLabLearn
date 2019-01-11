Shader "CookbookShaders/Chapter010/BSC"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }

    SubShader
    {
        pass
        {
            ZTest Always
            Cull Off
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed _BrightnessAmount;
            fixed _SaturationAmount;
            fixed _ContrastAmount;

            float3 ContrastSaturationBrightness(float3 color, float brt, float sat, float con)
            {
                float3 luminanceCoeff = float3(0.2125, 0.7154, 0.0721);
                float3 avgLuminance = float3(0.5, 0.5, 0.5);
                float3 brtColor = color * brt;
                float intensity = dot(brtColor, luminanceCoeff);
                float3 satColor = lerp((float3)intensity, brtColor, sat);
                float conColor = lerp(avgLuminance, satColor, con);
                return conColor;
            }

            fixed4 frag(v2f_img i) : COLOR
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                renderTex.rgb = ContrastSaturationBrightness(renderTex.rgb, 
                    _BrightnessAmount, _SaturationAmount, _ContrastAmount);
                return renderTex;
            }

            ENDCG

        }
    }

    FallBack Off
}
