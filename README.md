# CudaHomeworkRGB
### How to Use 
 ```bash
    $ git clone https://github.com/kevinbear/CudaHomeworkRGB.git
    $ cd /your/computer/project/path
    $ make RGB_G
    $ ./RGB input.bmp output.bmp RGB -g
 ```
 1. Open Terminal Clone the repository to your computer
 2. cd(change directory) to the project directory
 3. use make file to create binary executable file
 4. Use the binary executable file with input bmp file and output bmp name and program working mode
 + ./RGB : Binary executable file
 + input.bmp : In my prject alreadly have two bmp image (dog.bmp, pengin.bmp)
 + output.bmp : Input the output bmp image name
 + RGB : This is mode "RGB" denoted that cpu computation mode; "RGB -g" denoted that gpu computation mode
-----------------------------------------------------------------------------------------------------------
### Working Parameter
1. Terminal will show following :
```bash
Input RGB Value: 
eg. (10,30,20)
```
2. You must input rgb data : (120,0,0) or (0,120,0) or (0,0,120) or (10,100,255) etc...
    + Data Format: (R,G,B) --> (100,0,0)

