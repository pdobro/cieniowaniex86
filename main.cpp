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
   unsigned int x1;
	unsigned int y1;
	char r1;
	char g1;
	char b1;
	unsigned int x2;
	unsigned int y2;
	char r2;
	char g2;
	char b2;
	unsigned int x3;
	unsigned int y3;
	char r3;
	char g3;
	char b3;
} Triangle;

extern "C"  void shading(char * begColorArray, int height, int width,int rsize , Triangle* triangle);



void setVertices(Triangle *triangle)
{

    triangle -> x1 = 210;
    triangle -> y1 = 350;
    triangle -> r1 = 250;
    triangle -> g1 = 0;
    triangle -> b1 = 0;

    triangle -> x2 = 10;
    triangle -> x2 = 10;
    triangle -> r2 = 0;
    triangle -> g2 = 250;
    triangle -> b2 = 0;

    triangle -> x3 = 380;
    triangle -> y3 = 210;
    triangle -> r3 = 0;
    triangle -> g3 = 0;
    triangle -> b3 = 250;

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
      triangle.r2 = static_cast<char>(temp);
      std::cin>>temp;
      triangle.g2 = static_cast<char>(temp);
      std::cin>>temp;
      triangle.b2 = static_cast<char>(temp);

      std::cout<<"enter color val of 2 verticle"<<std::endl;
      std::cin>>temp;
      triangle.r1 = static_cast<char>(temp);
      std::cin>>temp;
      triangle.g1 = static_cast<char>(temp);
      std::cin>>temp;
      triangle.b1 = static_cast<char>(temp);

      std::cout<<"enter color val of 3 verticle"<<std::endl;
      std::cin>>temp;
      triangle.r3 = static_cast<char>(temp);
      std::cin>>temp;
      triangle.g3 = static_cast<char>(temp);
      std::cin>>temp;
      triangle.b3 = static_cast<char>(temp);
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
