import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAutenticacao extends StatefulWidget {
  @override
  _FirebaseAutenticacaoState createState() => _FirebaseAutenticacaoState();
}

class _FirebaseAutenticacaoState extends State<FirebaseAutenticacao> {
  FirebaseAuth auth = FirebaseAuth.instance;

  _singIn(email, senha) {

    auth
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((firebaseUser) {
      print("Novo usuario: Sucessor!! email: " + firebaseUser.email);
    }).catchError((erro) {
      print("Novo Usuario: erro " + erro.toString());
    });
  }

  _verificaLogado() async {
    FirebaseUser usuario = await auth.currentUser();

    if (usuario != null)
      print("Usuario atual logado => email: " + usuario.email);
    else
      print("Usuario atual DESLOGADO");
  }

  _logout() => auth.signOut();

  _login(email, senha) {
    auth
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((firebaseuser) {
      print("Usuario LOGADO_ " + firebaseuser.email);
    }).catchError((onError) {
      print("Falha no Login");
    });
  }

  @override
  Widget build(BuildContext context) {
    String email = "carlosifto@gmail.com";
    String senha = "castielsuller";

    _verificaLogado();
    _logout();
    _verificaLogado();
//    _login(email, senha);
//    _verificaLogado();
    return Container();
  }
}
