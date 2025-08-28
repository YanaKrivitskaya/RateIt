import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:rateit/models/api_models/api_attachments.model.dart';
import 'package:rateit/services/api.service.dart';
import 'package:rateit/models/attachment.model.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

class AttachmentsRepository {
  ApiService apiService = ApiService();
  String baseUrl = "attachments/";
  final log = Logger('AttachmentsRepository');

  Future<List<Attachment>?> createAttachments(int itemId, List<XFile> attachments) async{
    var url = "$baseUrl$itemId";
    log.info('createAttachments');

    List<ApiAttachmentModel> files = List.empty(growable: true);

    for (var att in attachments) {
      files.add(ApiAttachmentModel(await att.readAsBytes(), att.name));
    }

    final response = await apiService.postSecureMultipart(url, files);

    var attResponse = response["attachments"]?.map<Attachment>((map) =>
        Attachment.fromMap(map)).toList();
    return attResponse;
  }

  Future<Attachment?> getCoverAttachment(int itemId) async{
    var url = "$baseUrl$itemId";
    log.info('getCoverAttachment');

    final response = await apiService.getSecure(url);

    var attachment = response?["attachment"] != null ?
    Attachment.fromMap(response["attachment"]) : null;
    return attachment;
  }

  Future<Uint8List?> getAttachmentById(id) async{
    var url = "$baseUrl$id";
    log.info('getAttachmentById');
    final response = await apiService.getSecure(url, isRaw: true);

    return response.bodyBytes;
  }

  Future<void> deleteAttachment(id) async{
    var url = "$baseUrl$id";
    log.info('deleteAttachment');
    await apiService.deleteSecure(url);
  }

}