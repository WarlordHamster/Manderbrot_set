#include <SDL2/SDL.h>
#include <stdio.h>
#include <iostream>

extern "C" void mandelbrot(double x1, double x2, double y1, double y2, int pixelx, int pixely, SDL_Renderer* renderer,SDL_Window* window);
int main(int argc, char* argv[]) {
    SDL_Init(SDL_INIT_EVERYTHING);
    SDL_Event event;
    SDL_Window* window = nullptr;
    SDL_Renderer* renderer = nullptr;
    SDL_CreateWindowAndRenderer(1024,1024,0,&window,&renderer);
    SDL_RenderSetScale(renderer,1,1);
    double x1=-2, x2= 2, y1=-2, y2 = 2;
    int* pixelx;
    int* pixely;
    SDL_GetRendererOutputSize(renderer, pixelx, pixely);
    while(true){
        mandelbrot(x1,x2,y1,y2,*pixelx,*pixely,renderer,window);
        SDL_RenderPresent(renderer);
        if (SDL_PollEvent(&event) && event.type == SDL_QUIT)
            break;
    }
}
