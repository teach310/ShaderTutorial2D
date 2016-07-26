Shader "ShaderTutorial/Tutorial8"
{
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// 追加
		CGINCLUDE
		float mod(float  a, float  b) { return a-b*floor(a/b); } 
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
				return o;
			}

			// MOVING THE COORDINATE CENTER TO THE CENTER OF THE FRAME
			fixed4 frag (v2f i) : SV_Target
			{
				fixed2 r = 2.0 * fixed2(i.uv.x - 0.5, i.uv.y - 0.5);
				fixed3 backgroundColor = fixed3(1.0, 1.0, 1.0);
				fixed3 axesColor = fixed3(0.0, 0.0, 1.0);
				fixed3 gridColor = fixed3(0.5, 0.5, 0.5);

				fixed3 pixel = backgroundColor;

				const float tickWidth = 0.1;
				if( mod(r.x, tickWidth) < 0.008 ) pixel = gridColor;
				if( mod(r.y, tickWidth) < 0.008 ) pixel = gridColor;

				// Draw the axes
				if(abs(r.x)<0.006) pixel = axesColor;
				if(abs(r.y)<0.007) pixel = axesColor;

				return fixed4(pixel, 1.0);
			}


			ENDCG
		}
	}
}
