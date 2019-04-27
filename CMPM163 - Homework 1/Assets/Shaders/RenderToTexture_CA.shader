Shader "Custom/RenderToTexture_CA"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {} 
    }
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		
		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
            
            uniform float4 _MainTex_TexelSize;
           
            
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};
   
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
            
           
            sampler2D _MainTex;
            
			fixed4 frag(v2f i) : SV_Target
			{
            
                float2 texel = float2(
                    _MainTex_TexelSize.x, 
                    _MainTex_TexelSize.y 
                );
                
                float cx = i.uv.x;
                float cy = i.uv.y;
                
                // the current pixel
                float4 C = tex2D( _MainTex, float2( cx, cy ));   
                
                float up = i.uv.y + texel.y * 1;
                float down = i.uv.y + texel.y * -1;
                float right = i.uv.x + texel.x * 1;
                float left = i.uv.x + texel.x * -1;
                
                float4 arr[8];
                
                // obtain all neighboring texels
                arr[0] = tex2D(  _MainTex, float2( cx   , up ));   //N
                arr[1] = tex2D(  _MainTex, float2( right, up ));   //NE
                arr[2] = tex2D(  _MainTex, float2( right, cy ));   //E
                arr[3] = tex2D(  _MainTex, float2( right, down )); //SE
                arr[4] = tex2D(  _MainTex, float2( cx   , down )); //S
                arr[5] = tex2D(  _MainTex, float2( left , down )); //SW
                arr[6] = tex2D(  _MainTex, float2( left , cy ));   //W
                arr[7] = tex2D(  _MainTex, float2( left , up ));   //NW

                // int cnt = 0;
                // for(int i=0;i<8;i++){
                //     if (arr[i].r > 0.5) {
                //         cnt++;
                //     }
                // }

                // count the number of red, blue, and purple texels
                int cnt_red = 0;
                int cnt_blue = 0;
                int cnt_purple = 0;
                for(int i = 0; i < 8; i++)
                {
                    // if it is a red pixel, increment red count
                    if(arr[i].r > 0.5 && arr[i].b < 0.5 && arr[i].g < 0.5)
                    {
                        cnt_red++;
                    }
                    // else if it is a blue pixel, increment blue count
                    else if(arr[i].b > 0.5 && arr[i].r < 0.5 && arr[i].g < 0.5)
                    {
                        cnt_blue++;
                    }
                    // else if it is a purple pixel, increment purple count
                    else if(arr[i].r > 0.5 && arr[i].b > 0.5 && arr[i].g < 0.5)
                    {
                        cnt_purple++;
                    }
                }
                
                // calculate total texels
                int cnt = cnt_red + cnt_blue + cnt_purple;

                // if the cell is alive and purple
                if(C.r >= 0.5 && C.b >= 0.5 && C.g < 0.5)
                {
                    // if the cell has two or three neighbors, it lives
                    if (cnt == 2 || cnt == 3)
                    {
                        return float4(1.0, 0.0, 1.0, 1.0);
                    }
                    else // if the cell has less than 2 or more than 3 neigbors, it dies
                    {
                        return float4(1.0, 1.0, 1.0, 1.0);
                    }
                    // return float4(1.0, 0.0, 1.0, 1.0);
                }
                // else if the cell is alive and red
                else if(C.r >= 0.5 && C.b < 0.5 && C.g < 0.5)
                {
                    // if the cell has two or three neighbors, it lives
                    if(cnt == 2 || cnt == 3)
                    {
                        // if there are any purple texels, or more blue than red, the cell becomes purple
                        if(cnt_purple > 1 || cnt_blue > cnt_red + 1)
                        {
                            return float4(1.0, 0.0, 1.0, 1.0);
                        }
                        // else the cell remains red
                        else
                        {
                            return float4(1.0, 0.0, 0.0, 1.0);
                        }
                    }
                    else // if the cell has less than 2 or more than 3 neigbors, it dies
                    {
                        return float4(1.0, 1.0, 1.0, 1.0);
                    }
                    // return float4(1.0, 0.0, 0.0, 1.0);
                }
                // else if the cell is alive and blue
                else if(C.b >= 0.5 && C.r < 0.5 && C.g < 0.5)
                {
                    // if the cell has two or three neighbors, it lives
                    if(cnt == 2 || cnt == 3)
                    {
                        // if there are any purple texels, or more red than blue, the cell becomes purple
                        if(cnt_purple > 1 || cnt_red > cnt_blue + 1)
                        {
                            return float4(1.0, 0.0, 1.0, 1.0);
                        }
                        // else the cell remains blue
                        else
                        {
                            return float4(0.0, 0.0, 1.0, 1.0);
                        }
                    }
                    else // if the cell has less than 2 or more than 3 neigbors, it dies
                    {
                        return float4(1.0, 1.0, 1.0, 1.0);
                    }
                    // return float4(0.0, 0.0, 1.0, 1.0);
                }
                // else the cell is dead
                else
                {
                    // if the cell has 3 live neighbors, it comes to life
                    if(cnt == 3)
                    {
                        // if there are any purple cells, it becomes purple
                        if(cnt_purple > 0)
                        {
                            return float4(1.0, 0.0, 1.0, 1.0);
                        }
                        // else if there are more red than blue, it becomes red
                        else if(cnt_red > cnt_blue)
                        {
                            return float4(1.0, 0.0, 0.0, 1.0);
                        }
                        // else there are more blue than red, it becomes blue
                        else
                        {
                            return float4(0.0, 0.0, 1.0, 1.0);
                        }
                    }
                    else // else it stays dead
                    {
                        return float4(1.0, 1.0, 1.0, 1.0);
                    }
                    // return float4(1.0, 1.0, 1.0, 1.0);
                }

                // if (C.r >= 0.5) { //cell is alive
                //     if (cnt == 2 || cnt == 3) {
                //         //Any live cell with two or three live neighbours lives on to the next generation.
                
                //         return float4(1.0,1.0,1.0,1.0);
                //     } else {
                //         //Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
                //         //Any live cell with more than three live neighbours dies, as if by overpopulation.

                //         return float4(0.0,0.0,0.0,1.0);
                //     }
                // } else { //cell is dead
                //     if (cnt == 3) {
                //         //Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

                //         return float4(1.0,1.0,1.0,1.0);
                //     } else {
                //         return float4(0.0,0.0,0.0,1.0);

                //     }
                // }
                
            }

			ENDCG
		}

	}
	FallBack "Diffuse"
}