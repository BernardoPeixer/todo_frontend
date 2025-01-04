import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/style/panel_text_style.dart';
import '../../../../utils/outlined_button_default.dart';
import '../../../../utils/text_form_box_default.dart';
import '../../layers/data/dto/board_dto.dart';
import '../../layers/domain/usecases/home_page_usecase.dart';
import '../states/home_page_state.dart';

/// Stateless widget to build a home page ui
class HomePageUi extends StatelessWidget {
  /// Constructor
  HomePageUi({super.key});

  final _homePageUseCase = GetIt.instance.get<HomePageUseCase>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePageState(
        homePageUseCase: _homePageUseCase,
      ),
      child: Consumer<HomePageState>(builder: (_, state, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageHeaderDefault(),
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sua área de trabalho',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: material.Colors.deepPurple,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      for (final item in state.boardList)
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: WorkspaceContainer(
                            workspace: item,
                            boardId: item.id ?? 0,
                          ),
                        ),
                      const AddNewBoardButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// Class to define a add new board button
class AddNewBoardButton extends StatelessWidget {
  /// Constructor
  const AddNewBoardButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);
    return MouseRegion(
      onEnter: (_) {
        state.containerColor = material.Colors.black26;
      },
      onExit: (_) {
        state.containerColor = material.Colors.black12;
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => ChangeNotifierProvider.value(
                value: state, child: const CreateBoardDialog()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            height: 100,
            width: 200,
            decoration: BoxDecoration(
              color: state.containerColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                'Criar novo quadro',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Class to define workspace container UI
class WorkspaceContainer extends StatelessWidget {
  /// Constructor
  const WorkspaceContainer({
    super.key,
    required this.workspace,
    required this.boardId,
  });

  /// Workspace instance
  final BoardDto workspace;

  /// Board id
  final int boardId;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.go('/board/$boardId');
        },
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              workspace.title ?? '',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

/// Class to define page header
class PageHeaderDefault extends StatelessWidget {

  /// Title custom
  final String? customTitle;

  /// Constructor
  const PageHeaderDefault({
    super.key,
    this.customTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      child: Row(
        children: [
          Text(
            customTitle ?? 'STODOH',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(
            material.Icons.workspace_premium,
            color: Colors.white,
            size: 26,
          ),
        ],
      ),
    );
  }
}

/// Class to define a create board dialog
class CreateBoardDialog extends StatelessWidget {
  /// Constructor
  const CreateBoardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<HomePageState>(context);
    return ContentDialog(
      title: Text(
        'Criar quadro',
        style: PanelTextStyle.titlePoppinsModalFontStyle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormBoxDefault(
            header: 'Título do quadro',
            controller: state.titleController,
          ),
        ],
      ),
      actions: [
        OutlinedButtonDefault(
          title: 'Criar',
          onTap: () => state.addNewBoard(context),
        ),
      ],
    );
  }
}
