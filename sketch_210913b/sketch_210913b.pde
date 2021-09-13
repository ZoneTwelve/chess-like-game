Piece[] piece;
PFont myFont;
void setup(){
  size( 550, 650 );
  
  piece = new Piece[10];
  piece[0] = new Piece( 5, 5, "王" );
  piece[0].place( 1, 1 );
  myFont = createFont("標楷體",100);
  textFont(myFont);
  //noLoop();
}

void draw(){
  background( 255 );
  Piece p = piece[0];
  
  board();
  
  p.control( mouseX, mouseY, mousePressed );
  p.draw();
}

void board(){
  int size = 50;
  stroke( 0 );
  for( int y = 1 ; y <= 11 ; y++ ){
    for( int x = 1 ; x <= 9 ; x++){
      fill( 255 );
      if( y==5 )
        fill( 200, 200, 240 );
      rect( x * size, y * size, size, size );
    }
  }
}

public class Piece{
  float x, y, size, block;
  String name;
  boolean follow, drag;
  Piece(int _x, int _y, String _name){
    name = _name;
    block = 50;
    size = block/3*2;
    x = _x * size + block/2;
    y = _y * size + block/2;
    follow = false;
    drag   = false;
  }
  
  public void draw(){
    fill( 255 );
    stroke( follow ? color( 255, 0, 0 ) : color( 0 ) );
    circle( x, y, size );
    fill( 0 );
    textSize( 16 );
    text( name, x - textWidth(name)/2, y + textWidth(name)/4 );
  }
  
  public void place( float tx, float ty ){
    int rx = int( tx / block ),
        ry = int( ty / block );
    println( rx, ry );
    if( rx > 0 && rx <= 9 && ry > 0 && ry <= 11 ){
      x = (rx + 1) * block - block/2;
      y = (ry + 1) * block - block/2;
    }
  }  
  public void place( int rx, int ry ){
    if( rx > 0 && rx <= 9 && ry > 0 && ry <= 11 ){
      x = (rx + 1) * block - block/2;
      y = (ry + 1) * block - block/2;
    }
  }
  
  public void control( float tx, float ty, boolean _drag ){
    if( _drag && sqrt((x-tx)*(x-tx) + (y-ty)*(y-ty)) <= size/2 ){
       follow = true;
    }else if( !_drag && follow ){
      follow = false;
      place( tx, ty );
    }
    
    if( follow ){
      x = tx;
      y = ty;
    }
  }
};
