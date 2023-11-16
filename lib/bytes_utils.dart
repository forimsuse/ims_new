import 'dart:typed_data';

class BytesUtil{
  late Uint8List bytes;
  BytesUtil({required List<int> list}){
    bytes = Uint8List.fromList(list);
  }

  int getFrom8bit(int byteOffset){
    return bytes.buffer.asByteData().getUint8(byteOffset);
  }

  int getFrom16bit(int byteOffset){
    return bytes.buffer.asByteData().getUint16(byteOffset, Endian.little);
  }

  int getFrom16bitBig(int byteOffset){
    return bytes.buffer.asByteData().getUint16(byteOffset, Endian.big);
  }

  int getFrom32bit(int byteOffset){
    return bytes.buffer.asByteData().getUint32(byteOffset, Endian.little);
  }
  main(int byteOffset){
    // var list = [0, 2, 46, 80, 128, 106, 163, 130, 85, 170, 217, 250, 42, 21, 78, 45, 0, 85, 0, 0];
    // Uint8List serviceData = Uint8List.fromList(list);
    // ByteData data = ByteData.sublistView(serviceData, 0, 10); //for namespace 10 byte
    // var abc = bytes.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // var dta = utf8.decode(abc);
    // print(dta);
  }
}