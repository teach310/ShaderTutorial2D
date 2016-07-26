Shader "ShaderTutorial/Tutorial5"
{
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}


			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 color1 = fixed3(0.886, 0.576, 0.898);
				fixed3 color2 = fixed3(0.537, 0.741, 0.408);
				fixed3 pixel;

				float dis = 50;

				if(i.uv.x * _ScreenParams.x > dis){
					pixel = color2;
				} else {
					pixel = color1;
				}

				return fixed4(pixel, 1.0);
			}
			ENDCG
		}
	}
}
