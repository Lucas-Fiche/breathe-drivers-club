import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Volta para a tela anterior; se a tela foi aberta direto pela URL (sem
/// histórico), vai para [fallback]. Usado no botão voltar das telas cheias.
void popOrGo(BuildContext context, {String fallback = '/inicio'}) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallback);
  }
}
