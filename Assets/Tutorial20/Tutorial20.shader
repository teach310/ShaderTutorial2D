Shader "ShaderTutorial/Tutorial20"
{
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// 追加
		CGINCLUDE

		#define PI 3.14159

		// (anti-aliased)Gridを作る関数
		float coordinateGrid(float2 r){
			float3 axisCol = float3(0.0, 0.0, 1.0);
			float3 gridCol = float3(0.5, 0.5, 0.5);
			float ret = 0.0;

			// Draw grid lines
			const float tickWidth = 0.1;
			for(float i= -2.0;i<2.0; i+= tickWidth){
				ret += 1.0 - smoothstep(0.0, 0.008, abs (r.x - i));
				ret += 1.0 - smoothstep(0.0, 0.008, abs (r.y - i));
			}

			// Draw the axis
			ret += 1.0-smoothstep(0.001, 0.015, abs(r.x));
			ret += 1.0-smoothstep(0.001, 0.015, abs(r.y));
			return ret;
		}

		// returns 1.0 if inside circle
		float disk(float2 r, float2 center, float radius){
			return 1.0 - smoothstep( radius - 0.005, radius + 0.005, length(r - center));
		}

		// returns 1.0 if inside the rect
		float rectangle(float2 r, float2 bottomLeft, float2 topRight){
			float ret;
			float d = 0.005;
			ret = smoothstep(bottomLeft.x - d, bottomLeft.x + d, r.x);
			ret *= smoothstep(bottomLeft.y - d, bottomLeft.y + d, r.y);
			ret *= 1.0 - smoothstep(topRight.y - d, topRight.y + d, r.y);
			ret *= 1.0 - smoothstep(topRight.x - d, topRight.x + d, r.x);
			return ret;
		}

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
				o.uv.y = 1-o.uv.y;
				return o;
			}

			//ANIMATION
			fixed4 frag (v2f i) : SV_Target
			{
				float2 r = 2.0 * (i.uv - 0.5);
				float aspectRatio = _ScreenParams.x / _ScreenParams.y;
				r.x *= aspectRatio;

				fixed3 bgCol = float3(1.0, 1.0, 1.0); // white
		
				fixed3 col1 = float3(0.216, 0.471, 0.698); // blue
				fixed3 col2 = float3(1.00, 0.329, 0.298); // red
				fixed3 col3 = float3(0.867, 0.910, 0.247); // yellow

				fixed3 ret;
				ret = bgCol;

				float angle = -0.6;
				float2x2 rotationMatrix = float2x2(cos(angle), -sin(angle),
												sin(angle), cos(angle));

				
				if(i.uv.x < 1.0/5.0) // part1
				{
					float2 q = r + float2(aspectRatio*4.0/5.0, 0);

					ret = fixed3(0.3, 0.3, 0.3);
					//時間は_Time.yで取得できる
					float y = _Time.y;

					//yを-1 ~ 1の値にする
					y = mod(y,2.0) -1.0;
					ret = lerp(ret, col1, disk(q, float2(0.0, y), 0.1));
				}
				else if(i.uv.x < 2.0/5.0) //part2
				{
					float2 q = r + float2(aspectRatio*2.0/5.0, 0);
					ret = fixed3(0.4, 0.4, 0.4);
					//振幅
					float amplitude = 0.8;
					float y = 0.8 * sin(0.5*_Time.y* 2.0 * PI);
					float radius = 0.15 + 0.05 * sin(_Time.y * 8.0);
					ret = lerp(ret, col1, disk(q, float2(0.0, y), radius));
				}
				else if(i.uv.x < 3.0/5.0) //part3
				{
					float2 q = r + float2(aspectRatio*0/5.0, 0);
					ret = float3(0.5, 0.5, 0.5);

					float x = 0.2*cos(_Time.y*5.0);
					float y = 0.3*sin(_Time.y*5.0);
					float radius = 0.2 + 0.1*sin(_Time.y*2.0);
					fixed3 color = lerp(col1, col2, sin(_Time.y)*0.5 + 0.5);
					ret = lerp(ret, color, rectangle(q, float2(x-0.1, y-0.1), float2(x+0.1, y+0.1)));
				}
				else if(i.uv.x < 4.0/5.0) //part4
				{
					float2 q = r + float2(-aspectRatio*2.0/5.0, 0);
					ret = float3(0.4, 0.4, 0.4);

					for(float i=-1.0; i<1.0; i+= 0.2)
					{
						float x = 0.2 * cos(_Time.y*5.0 + i*PI);
						float y = i;

						float2 s = q - float2(x, y);
						float angle = _Time.y * 3.0 + i;
						float2x2 rot = float2x2(cos(angle), -sin(angle),
												sin(angle),  cos(angle));
						s = mul(rot, s);
						ret = lerp(ret, col1, rectangle(s, float2(-0.06, -0.06), float2(0.06, 0.06)));
					}
				}
				else if(i.uv.x < 5.0/5.0) //part5
				{
					float2 q = r + float2(-aspectRatio*4.0/5.0, 0);
					ret = float3(0.3, 0.3, 0.3);

					float speed = 2.0;
					float t = _Time.y * speed;
					float stopEveryAngle = PI / 2.0;
					float stopRatio = 0.5;
					//0.5<frac(t)<1の時,t1は一定となる。そこで止まっている。
					float t1 = (floor(t) + smoothstep(0.0, 1.0 - stopRatio, frac(t)))*stopEveryAngle;

					float x = -0.2*cos(t1);
					float y = 0.3 * sin(t1);
					float dx = 0.1 + 0.03 * sin(t*10.0);
					float dy = 0.1 + 0.03 * sin(t*10.0+PI);
					ret = lerp(ret, col1, rectangle(q, float2(x-dx, y-dy), float2(x+dx, y+dy)));

				
				}






				fixed3 pixel = ret;
				return fixed4(pixel, 1.0);
			}


			ENDCG
		}
	}
}
