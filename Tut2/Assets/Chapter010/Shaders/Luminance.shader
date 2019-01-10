Shader "CookbookShaders/Chapter010/Luminance"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}    
        _LuminosityAmount ("Gray Scale Amount", Range(0, 1)) = 0.5
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
            fixed _LuminosityAmount;

            fixed4 frag(v2f_img i) : COLOR
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);

                float luminosity = Luminance(renderTex.rgb);
                fixed4 finalColor = lerp(renderTex, luminosity, _LuminosityAmount);

                return finalColor;
            }

            ENDCG

        }
    }

    FallBack Off
}
