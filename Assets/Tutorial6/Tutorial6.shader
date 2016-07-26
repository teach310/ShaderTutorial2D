Shader "ShaderTutorial/Tutorial6"
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

			// HORIZONTAL AND VERTICAL LINES
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 backgroundColor = fixed3(1.0, 1.0, 1.0);
				fixed3 color1 = fixed3(0.216, 0.471, 0.698); // blue
				fixed3 color2 = fixed3(1.00, 0.329, 0.298); // red
				fixed3 color3 = fixed3(0.867, 0.910, 0.247); // yellow

				fixed3 pixel = backgroundColor;

				// line1
				float leftCoord = 0.54;
				float rightCoord = 0.55;
				if(i.uv.x < rightCoord && i.uv.x > leftCoord) pixel = color1;

				// line2
				float lineCoordinate = 0.4;
				float lineThickness = 0.003;
				if(abs(i.uv.x - lineCoordinate) < lineThickness ) pixel = color2;

				// line3
				if(abs(i.uv.y - 0.6) < 0.01) pixel = color3;

				return fixed4(pixel, 1.0);
			}
			ENDCG
		}
	}
}
