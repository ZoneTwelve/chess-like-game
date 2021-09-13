Piece[] piece;
PFont myFont;
void setup(){
  size( 500, 550 );
  piece = new Piece[10];
  piece[0] = new Piece( 5, 5, "王" );
  myFont = createFont("標楷體",100);
  textFont(myFont);
  //noLoop();
}

void draw(){
  background( 255 );
  int size = 50;
  for( int y = 1 ; y < 10 ; y++ ){
    for( int x = 1 ; x < 9 ; x++){
      fill( 255 );
      if( y==5 )
        fill( 200, 200, 240 );
      rect( x * size, y * size, size, size );
      //line( x * size, 0, x * size, height );
      //line( 0, y * size, width, y * size );
    }
  }
  Piece p = piece[0];

  stroke( 0 );
  //println(mousePressed);
  if( p.detect( mouseX, mouseY ) && mousePressed){
    //println(mousePressed);
    p.x = mouseX;
    p.y = mouseY;
    stroke( 255, 0, 0 );
  }
  p.draw();
}
public class Piece{
  float x, y, size, block;
  String name;
  boolean touch;
  Piece(int _x, int _y, String _name){
    name = _name;
    block = 50;
    size = block/3*2;
    x = _x * size + block/2;
    y = _y * size + block/2;
    touch = false;
  }
  
  public void draw(){
    fill( 255 );
    circle( x, y, size );
    fill( 0 );
    textSize( 16 );
    text( name, x - textWidth(name)/2, y + textWidth(name)/4 );
  }
  
  public boolean detect( float tx, float ty ){
    if( sqrt((x-tx)*(x-tx) + (y-ty)*(y-ty)) <= size/2 ){
      return true;
    }
    return false;
  }
};
