#include <SDL2/SDL.h>
#include <stdio.h>
#include <iostream>
void zoom_in(double *x1, double *x2, double *y1, double *y2, double mouse_x, double mouse_y,int pixelx,int pixely){
    double zoom_factor = 0.5;
    double width = *x2 - *x1;
    double height = *y2 - *y1;
    double center_x = *x1 + (mouse_x / (double)pixelx) * width;
    double center_y = *y1 + (mouse_y / (double)pixely) * height;
    *x1 = *x1 + (center_x-*x1)*zoom_factor;
    *x2 = *x2 + (center_x-*x2)*zoom_factor;
    *y1 = *y1 + (center_y-*y1)*zoom_factor;
    *y2 = *y2 + (center_y-*y2)*zoom_factor;
}
void zoom_out(double *x1, double *x2, double *y1, double *y2, double mouse_x, double mouse_y,int pixelx,int pixely){
    double zoom_factor = -0.5;
    double width = *x2 - *x1;
    double height = *y2 - *y1;
    double center_x = *x1 + (mouse_x / (double)pixelx) * width;
    double center_y = *y1 + (mouse_y / (double)pixely) * height;
    *x1 = *x1 + (center_x-*x1)*zoom_factor;
    *x2 = *x2 + (center_x-*x2)*zoom_factor;
    *y1 = *y1 + (center_y-*y1)*zoom_factor;
    *y2 = *y2 + (center_y-*y2)*zoom_factor;
}
void reset(double *x1, double *x2, double *y1, double *y2, double mouse_x, double mouse_y,int pixelx,int pixely){
    *x1 = -2;
    *x2 = 1.2;
    *y1 = -1.5;
    *y2 = 1.5;
}
extern "C" void mandelbrot(double x1, double x2, double y1, double y2, int pixelx, int pixely,void* buffor);
int main(int argc, char* argv[]) {
    SDL_Init(SDL_INIT_EVERYTHING);
    SDL_Event event;
    SDL_Window* window = nullptr;
    SDL_Renderer* renderer = nullptr;
    SDL_CreateWindowAndRenderer(1024,1024,0,&window,&renderer);
    double x1=-2, x2= 1.2, y1=-1.5, y2 = 1.5;
    int pixelx;
    int pixely;
    int pitch;
    SDL_GetRendererOutputSize(renderer, &pixelx, &pixely);
    std::cout<<pixelx<<pixely;
    size_t size = size_t((pixelx)*(pixely)*4);
    void* buffor = malloc (size);
    SDL_GetRenderer(window);
    SDL_Texture* texture = SDL_CreateTexture
    (renderer, SDL_PIXELFORMAT_RGBA8888,SDL_TEXTUREACCESS_STREAMING,pixelx, pixely);
    SDL_LockTexture(texture, NULL,&buffor,&pitch);
    mandelbrot(x1,x2,y1,y2,pixelx,pixely,buffor);
    SDL_UnlockTexture(texture); 
    SDL_RenderClear(renderer);
    SDL_RenderCopy(renderer, texture, NULL, NULL);
    SDL_RenderPresent(renderer);
    bool running =true;
    int mouse_x=0,mouse_y=0;
    while(running){
        if(SDL_PollEvent(&event)){
            if (event.type == SDL_QUIT)running=false;
            else if(event.type == SDL_MOUSEBUTTONUP){
                SDL_GetMouseState(&mouse_x,&mouse_y);
                std::cout<<x1<<" "<<x2<<" "<<y1<<" "<<y2<<std::endl;
                if(SDL_BUTTON_LEFT == event.button.button){
                    zoom_in(&x1,&x2,&y1,&y2,mouse_x,mouse_y,pixelx,pixely);
                }
                else if(SDL_BUTTON_RIGHT == event.button.button){
                    zoom_out(&x1,&x2,&y1,&y2,mouse_x,mouse_y,pixelx,pixely);
                }
                else if(SDL_BUTTON_MIDDLE == event.button.button){
                    reset(&x1,&x2,&y1,&y2,mouse_x,mouse_y,pixelx,pixely);
                }

            }
            
        }
        SDL_LockTexture(texture, NULL,&buffor,&pitch);
        mandelbrot(x1,x2,y1,y2,pixelx,pixely,buffor);
        SDL_UnlockTexture(texture); 
        SDL_RenderClear(renderer);
        SDL_RenderCopy(renderer, texture, NULL, NULL);
        SDL_RenderPresent(renderer);
    }
    
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    free(buffor);
}

