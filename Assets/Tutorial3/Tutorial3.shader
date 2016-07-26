Shader "ShaderTutorial/Tutorial3"
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
				fixed redAmount = 0.6;
				fixed greenAmount = 0.2;
				fixed blueAmount = 0.9;

				fixed3 color = fixed3(0.0, 0.0, 0.0);
				color.x = redAmount;
				color.y = greenAmount;
				color.z = blueAmount;

				fixed alpha = 1.0;
				fixed4 pixel = fixed4(color, alpha);
				return pixel;
			}
			ENDCG
		}
	}
}
