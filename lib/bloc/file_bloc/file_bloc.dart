import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp_1/model/uploaded_file.dart';

abstract class FileUploadStates {}

abstract class FileUploadEvent {}

class FileUploadAdded extends FileUploadEvent {
  final UploadedFilesModel file;
  FileUploadAdded(this.file);
}

class FileUploadInitialised extends FileUploadStates {}

class FileUploading extends FileUploadStates {}

class FileUploaded extends FileUploadStates {}

class FileUploadFailed extends FileUploadStates {
  final String errorMessage;
  FileUploadFailed(this.errorMessage);
}

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadStates> {
  FileUploadBloc() : super(FileUploadInitialised()) {
    on<FileUploadAdded>((event, emit) async {
      try {
        emit(FileUploading());
        var fileRef = FirebaseStorage.instance.ref();
        print("images/${event.file.url.split("/").last}");
        var pdfRef = fileRef.child("images/${event.file.url.split("/").last}");
        var task = await pdfRef.putFile(File(event.file.url));

        var downloadUrl = await task.ref.getDownloadURL();
        UploadedFilesModel file = event.file.copyWith(
          url: downloadUrl,
        );
        FirebaseFirestore.instance
            .collection("/test")
        .doc(FirebaseAuth.instance.currentUser!.uid).collection("images")
            .add(file.toMap());
        emit(FileUploaded());
      } catch (error) {
        emit(FileUploadFailed(error.toString()));
      }
    });
  }
}

class GetFilesBloc {
  Stream<List<UploadedFilesModel>> getFiles() {
    return FirebaseFirestore.instance.collection("/test").doc(FirebaseAuth.instance.currentUser!.uid).collection("images").snapshots().map((event) {

    return event.docs.map((e) => UploadedFilesModel.fromMap(e.data())).toList();
    });
  }
}