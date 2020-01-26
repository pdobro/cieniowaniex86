#include<allegro5/allegro.h>
#include <allegro5/allegro_image.h>
#include <allegro5/allegro_native_dialog.h>
#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <algorithm>

#define HEIGHT 400
#define WIDTH 400

typedef struct 
{
   unsigned int ax;
	unsigned int ay;
	char ar;
	char ag;
	char ab;
	unsigned int bx;
	unsigned int by;
	char br;
	char bg;
	char bb;
	unsigned int cx;
	unsigned int cy;
	char cr;
	char cg;
	char cb;
} Triangle;

extern "C"  void shading(char * begColorArray, int height, int width,int rsize , Triangle* triangle);



void setVertices(Triangle *triangle)
{

    triangle -> ax = 210;
    triangle -> ay = 350;
    triangle -> ar = 250;
    triangle -> ag = 0;
    triangle -> ab = 0;

    triangle -> bx = 10;
    triangle -> by = 10;
    triangle -> br = 0;
    triangle -> bg = 250;
    triangle -> bb = 0;

    triangle -> cx = 380;
    triangle -> cy = 210;
    triangle -> cr = 0;
    triangle -> cg = 0;
    triangle -> cb = 250;

}

int main()
{
    ALLEGRO_DISPLAY *display = NULL;
    ALLEGRO_BITMAP  *image   = NULL;


   std::fstream file;
   file.open("input.bmp", std::ios::in | std::ios::binary);

   char *buffer;
   buffer = new char[154];
	int fileSize,offset, arrayWidth, arrayHeight, arraySize;
	file.seekg(+2, std::ios_base::beg);
	file.read((char*)&fileSize, 4 );
	file.seekg(+10, std::ios_base::beg);
	file.read((char*)&offset, 4);
	file.seekg(+18, std::ios_base::beg);
	file.read((char*)&arrayWidth, 4);
	file.read((char*)&arrayHeight, 4);
	file.seekg(+8, std::ios_base::cur);
	file.read((char*)&arraySize, 4);
	file.seekg(0, std::ios_base::beg);
	file.read(buffer, offset);
	char* begColorArray = new char[arraySize];
	file.read(begColorArray, arraySize);
	file.close();

	Triangle triangle;
   setVertices(&triangle);

	int rowSize = ((24 * arrayWidth + 31) / 32) * 4;//bits per pixel* width + 31/32 * 4
   while(1)
{
   shading(begColorArray, arrayHeight, arrayWidth, rowSize, &triangle);
   file.open("output.bmp", std::ios::out | std::ios::binary | std::ios::trunc);
	file.write(buffer, offset);
	file.write(begColorArray, arraySize);
	file.close();

   if(!al_init()) {
      al_show_native_message_box(display, "Error", "Error", "Failed to initialize allegro!", 
                                 NULL, ALLEGRO_MESSAGEBOX_ERROR);
      return 0;
   }

   if(!al_init_image_addon()) {
      al_show_native_message_box(display, "Error", "Error", "Failed to initialize al_init_image_addon!", 
                                 NULL, ALLEGRO_MESSAGEBOX_ERROR);
      return 0;
   }

   display = al_create_display(WIDTH,HEIGHT);

   if(!display) {
      al_show_native_message_box(display, "Error", "Error", "Failed to initialize display!", 
                                 NULL, ALLEGRO_MESSAGEBOX_ERROR);
      return 0;
   }

   image = al_load_bitmap("output.bmp");

   if(!image) {
      al_show_native_message_box(display, "Error", "Error", "Failed to load image!", 
                                 NULL, ALLEGRO_MESSAGEBOX_ERROR);
      al_destroy_display(display);
      return 0;
   }

   //al_unlock_bitmap(image);
   al_draw_bitmap(image,0,0,0);

   al_flip_display();
   al_rest(3);

   al_destroy_display(display);
   al_destroy_bitmap(image);
   char in;
   std::cout<<"want change vertices color?y/n  ";
   std::cin >>in;
   if (in == 'y')
   {
      int temp;
      std::cout<<"enter color val of 1 verticle"<<std::endl;
      std::cin>>temp;
      triangle.br = static_cast<char>(temp);
      std::cin>>temp;
      triangle.bg = static_cast<char>(temp);
      std::cin>>temp;
      triangle.bb = static_cast<char>(temp);

      std::cout<<"enter color val of 2 verticle"<<std::endl;
      std::cin>>temp;
      triangle.ar = static_cast<char>(temp);
      std::cin>>temp;
      triangle.ag = static_cast<char>(temp);
      std::cin>>temp;
      triangle.ab = static_cast<char>(temp);

      std::cout<<"enter color val of 3 verticle"<<std::endl;
      std::cin>>temp;
      triangle.cr = static_cast<char>(temp);
      std::cin>>temp;
      triangle.cg = static_cast<char>(temp);
      std::cin>>temp;
      triangle.cb = static_cast<char>(temp);
   }
   else
   {
      break;
   }
   
}

	delete[] buffer;
	delete[] begColorArray;
   return 0;

}
