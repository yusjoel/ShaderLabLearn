Shader "CookbookShaders/Chapter011/OldFilm"
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
            // 划痕
            sampler2D _ScratchesTex;
            // 灰尘
            sampler2D _DustTex;
            // 褐色
            fixed4 _SepiaColor;
            fixed _VignetteAmount;
            fixed _ScratchesXSpeed;
            fixed _ScratchesYSpeed;
            fixed _DustXSpeed;
            fixed _DustYSpeed;
            fixed _EffectAmount;
            fixed _RandomValue;

            fixed4 frag(v2f_img i) : COLOR
            {
                half2 renderTexUV = half2(i.uv.x, i.uv.y + (_RandomValue * _SinTime.z * 0.005));
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);

                half2 scratchesUV = half2(i.uv.x + _RandomValue * _SinTime.z * _ScratchesXSpeed,
                                          i.uv.y + _Time.x * _ScratchesYSpeed);
                fixed4 scratchesTex = tex2D(_ScratchesTex, scratchesUV);

                half2 dustUV = half2(i.uv.x + _RandomValue * _SinTime.z * _DustXSpeed,
                                     i.uv.y + _RandomValue * _SinTime.z * _DustYSpeed);
                fixed4 dustTex = tex2D(_DustTex, dustUV);

                fixed luminance = Luminance(renderTex.rgb);
                fixed4 finalColor = luminance +lerp(_SepiaColor, _SepiaColor + (fixed)0.1, _RandomValue);

                fixed3 constantWhite = fixed3(1, 1, 1);
                finalColor = lerp(finalColor, finalColor * vignetteTex, _VignetteAmount);
                finalColor.rgb *= lerp(scratchesTex, constantWhite, _RandomValue);
                finalColor.rgb *= lerp(dustTex.rgb, constantWhite, _RandomValue * _SinTime.z);
                finalColor = lerp(renderTex, finalColor, _EffectAmount);

                return finalColor;
            }

            ENDCG

        }
    }

    FallBack Off
}
