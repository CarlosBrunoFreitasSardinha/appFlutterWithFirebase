import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UploadImagesFirebase extends StatefulWidget {
  @override
  _UploadImagesFirebaseState createState() => _UploadImagesFirebaseState();
}

class _UploadImagesFirebaseState extends State<UploadImagesFirebase> {
  File _imagem;
  String _statusUpload = "Upload não iniciado";
  String _imagemRecuperada = "";

  Future _recuperarImagem(bool isCamera) async {
    File imagemSelecionada;
    if (isCamera) {
      imagemSelecionada =
      await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      imagemSelecionada =
      await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imagem = imagemSelecionada;
    });
  }

  Future _uploadImagem() async {
    //referencia arquivo
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child("images").child("Foto1.jpg");

    //fazendo o upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    //acompanhando o progresso do upload
    task.events.listen((StorageTaskEvent storageEvent){
      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _statusUpload = "Em progresso";
        });
      }else if (storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _statusUpload = "Upload Realizado!!!";
        });
      }
    });

    //recuperando url da imagem
    task.onComplete.then(
        (StorageTaskSnapshot snapshot) {
          _recuperarUrlImagem(snapshot);
        }
    );
  }
  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async{
    String url = await snapshot.ref.getDownloadURL();
    setState(() {
      _imagemRecuperada = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar imagens"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(_statusUpload),
            RaisedButton(
                child: Text("Camera"),
                onPressed: () {
                  _recuperarImagem(true);
                }),
            RaisedButton(
                child: Text("Galeria"),
                onPressed: () {
                  _recuperarImagem(false);
                }),
            _imagem == null ? Container() : Image.file(_imagem),

            _imagem == null ? Container() : RaisedButton(
                child: Text("UploadStorage"),
                onPressed: () {
                  _uploadImagem();
                }),
          _imagemRecuperada == "" ? Container() : Image.network(_imagemRecuperada),
          ],
        ),
      ),
    );
  }
}
