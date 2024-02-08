import 'package:flutter/material.dart';
import 'package:gastos/globals.dart';
import 'package:gastos/src/mes/blocs/mes_cubit.dart';
import 'package:gastos/src/pagamento/pagamento_page.dart';
import 'package:gastos/src/shared/components/alert_dialog.dart';
import 'package:gastos/src/shared/models/Gasto.dart';
import 'package:gastos/src/shared/models/Tag.dart';
import 'package:gastos/src/shared/repositories/GastoHelper.dart';
import 'package:gastos/src/shared/saldo_utils.dart';
import 'package:intl/intl.dart';

Widget getSaldoTexto(double saldo) {
  return Text(
    'Saldo: \$${saldo.toStringAsFixed(2)}',
    style: const TextStyle(color: Colors.white),
  );
}

Widget getCategoryTextOrIcon(Tag tag) {
  String category = tag.nome!;
  var icon = null;
  tagsPadroes.forEach((key, value) {
    if (key == category) {
      icon = Icon(value);
    }
  });
  if (icon != null) {
    return icon;
  }
  return Text(
    category,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget getGastosPositivos() {
  GastoHelper gastoHelper = GastoHelper();
  return FutureBuilder(
    future: gastoHelper.getGastosDoMesComQuantidadePositiva(DateFormat('y').format(DateTime.now()), DateFormat('MM').format(DateTime.now())),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data!.isEmpty) {
          return const Text(
            '\$0.0',
            style: TextStyle(color: Colors.white),
          );
        }
        double gastosTotal = 0;
        for (int i = 0; i < snapshot.data!.length; i++) {
          gastosTotal += snapshot.data![i].quantidade!;
        }
        String strGastosTotal = gastosTotal.toStringAsFixed(2);
        return Text(
          '\$$strGastosTotal',
          style: const TextStyle(color: Colors.green),
        );
      } else {
        return const Text(
          '\$0.0',
          style: TextStyle(color: Colors.white),
        );
      }
    },
  );
}

Widget getGastosNegativos() {
  GastoHelper gastoHelper = GastoHelper();
  return FutureBuilder(
    future: gastoHelper.getGastosDoMesComQuantidadeNegativa(DateFormat('y').format(DateTime.now()), DateFormat('MM').format(DateTime.now())),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data!.isEmpty) {
          return const Text(
            '\$0.0',
            style: TextStyle(color: Colors.white),
          );
        }
        double gastosTotal = 0;
        for (int i = 0; i < snapshot.data!.length; i++) {
          gastosTotal += snapshot.data![i].quantidade!;
        }
        String strGastosTotal = (gastosTotal * -1).toStringAsFixed(2);
        return Text(
          '\$$strGastosTotal',
          style: const TextStyle(color: Colors.red),
        );
      } else {
        return const Text(
          '\$0.0',
          style: TextStyle(color: Colors.white),
        );
      }
    },
  );
}

Widget buildEmptyState() {
  return const Column(
    children: [
      SizedBox(height: 20.0),
      Text('Nenhuma transação encontrada.'),
    ],
  );
}

void adicionarTransacao(MesCubit mesCubit, DateTime data, BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return const AdicionarTransacaoModal();
    },
  );
  mesCubit.changeGastos(data);
  mesCubit.changeSaldo(data);
}

Future<void> excluirGasto(Gasto gasto, BuildContext context, MesCubit mesCubit, DateTime data) async {
  var alerta = await const Alerta(
    text: 'Deseja excluir o gasto?',
    action: 'Sim',
    cancel: 'Cancelar',
  ).show(context);

  GastoHelper gastoHelper = GastoHelper();
  if (alerta) {
    await gastoHelper.removerGastoPorId(gasto.id!);
    print("Excluindo gasto");
  }
  else {
    print("Não excluindo gasto");
  }

  mesCubit.changeGastos(data);
  mesCubit.changeSaldo(data);
}