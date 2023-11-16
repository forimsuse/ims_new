
enum EnCommand {
  idle(code: 0, header: null),
  continuousSample(code: 1, header: '0xA55A'),
  continuousSample2(code: 1, header: '0xA55B'),
  updateRTC(code: 2, header: null),
  getID(code: 3, header: '0xA55C'),
  stop(code: 8, header: null),
  getRTC(code: 9, header: '0xA55F'),
  setSettings(code: 11, header: null),
  getSettings(code: 12, header: '0xA520'),
  deleteRecord(code: 13, header: null),
  startDFU(code: 0xB1, header: null),
  hardReset(code: 0xAA, header: null),
  selfTest(code: 20, header: null),
  getRecord(code: 4, header: '0xA55E'),
  nack(code: 0, header: '0xA560'),
  ack(code: 0, header: '0xA515'); //??


  const EnCommand({required this.code, required this.header});

  @override
  String toString(){
    return name;
  }

  final int code;
  final String? header;
}