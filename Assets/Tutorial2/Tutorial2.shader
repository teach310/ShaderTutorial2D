Shader "ShaderTutorial/Tutorial2"
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
				fixed3 color = fixed3(0.0, 1.0, 1.0);
				fixed alpha = 1.0;

				fixed4 pixel = fixed4(color, alpha);
				return pixel;
			}
			ENDCG
		}
	}
}
