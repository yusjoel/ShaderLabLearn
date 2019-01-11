Shader "CookbookShaders/Chapter011/NightVision"
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
            // 晕影
            sampler2D _VignetteTex;
            // 扫描线
            sampler2D _ScanLineTex;
            // 噪音
            sampler2D _NoiseTex;
            fixed4 _NightVisionColor;
            fixed _Contrast;
            fixed _ScanLineTileAmount;
            fixed _Brightness;
            fixed _RandomValue;
            fixed _NoiseXSpeed;
            fixed _NoiseYSpeed;
            fixed _Distortion;
            fixed _Scale;

            float2 barrelDistortion(float2 coord)
            {
                float2 h = coord.xy - float2(0.5, 0.5);
                float r2 = h.x * h.x + h.y * h.y;
                float f = 1 + r2 * (_Distortion * sqrt(r2));
                return f * _Scale * h + 0.5;
            }
            

            fixed4 frag(v2f_img i) : COLOR
            {
                half2 distortedUV = barrelDistortion(i.uv);
                fixed4 renderTex = tex2D(_MainTex, distortedUV);
                fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);

                half2 scanLinesUV = half2(i.uv.x * _ScanLineTileAmount,
                                          i.uv.y * _ScanLineTileAmount);
                fixed4 scanLineTex = tex2D(_ScanLineTex, scanLinesUV);

                half2 noiseUV = half2(i.uv.x + _RandomValue * _SinTime.z * _NoiseXSpeed,
                                      i.uv.y + _Time.x * _NoiseYSpeed);
                fixed4 noiseTex = tex2D(_NoiseTex, noiseUV);

                fixed luminance = Luminance(renderTex.rgb) + _Brightness;
                fixed4 finalColor = luminance * 2 + _NightVisionColor;

                finalColor = pow(finalColor, _Contrast);
                finalColor *= vignetteTex;
                finalColor *= scanLineTex * noiseTex;

                return finalColor;
            }

            ENDCG

        }
    }

    FallBack Off
}
