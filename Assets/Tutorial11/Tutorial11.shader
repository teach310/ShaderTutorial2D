Shader "ShaderTutorial/Tutorial11"
{
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// 追加
		CGINCLUDE
		fixed3 disk(fixed2 r, fixed2 center, fixed radius, fixed3 color, fixed3 pixel){
			fixed3 col = pixel;
			if(length(r - center) < radius){
				col = color;
			}
			return col;
		}
		ENDCG


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
				o.uv.y = 1-o.uv.y;
				return o;
			}

			// Functions
			fixed4 frag (v2f i) : SV_Target
			{
				float2 r = 2.0 * (i.uv - 0.5);
				float aspectRatio = _ScreenParams.x / _ScreenParams.y;
				r.x *= aspectRatio;

				fixed3 backgroundColor = fixed3(0.3, 0.3, 0.3);
				fixed3 col1 = fixed3(0.216, 0.471, 0.698); // blue
				fixed3 col2 = fixed3(1.00, 0.329, 0.298); // red
				fixed3 col3 = fixed3(0.867, 0.910, 0.247); // yellow

				fixed3 pixel = backgroundColor;
				
				pixel = disk(r, fixed2(0.1, 0.3), 0.5, col3, pixel);
				pixel = disk(r, fixed2(-0.8, -0.6), 1.5, col1, pixel);
				pixel = disk(r, fixed2(0.8, 0.0), 0.15, col2, pixel);


				return fixed4(pixel, 1.0);
			}


			ENDCG
		}
	}
}
