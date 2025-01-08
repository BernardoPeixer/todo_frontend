import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/style/panel_colors.dart';
import '../../../../core/style/panel_padding.dart';
import '../../../../core/style/panel_text_style.dart';
import '../../../../utils/content_dialog_default.dart';
import '../../../../utils/outlined_button_default.dart';
import '../../../../utils/text_form_box_default.dart';
import '../../layers/data/dto/board_dto.dart';
import '../../layers/data/dto/task_dto.dart';
import '../../layers/data/dto/task_list_dto.dart';
import '../../layers/domain/usecases/board_page_usecase.dart';
import '../states/board_page_state.dart';
import '../states/task_modal_state.dart';

/// Widget to build a board page UI
class BoardPageUi extends StatelessWidget {
  /// Constructor
  const BoardPageUi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final boardPageUseCase = GetIt.instance.get<BoardPageUsecase>();

    return ChangeNotifierProvider(
      create: (context) => BoardPageState(
        boardPageUseCase: boardPageUseCase,
      ),
      child: Consumer<BoardPageState>(builder: (_, state, __) {
        final board = state.boardDto;
        return state.isLoading
            ? const Center(
                child: ProgressRing(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      color: PanelColors.backgroundBoardColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _SideMenu(),
                          Padding(padding: PanelPadding.horizontalItem),
                          state.boardId == null
                              ? const _NoBoardSelected()
                              : _PageContent(
                                  board: board,
                                  boardPageUseCase: boardPageUseCase,
                                  state: state,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}

class _NoBoardSelected extends StatelessWidget {
  const _NoBoardSelected();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            'Nenhum quadro selecionado',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({
    required this.board,
    required this.boardPageUseCase,
    required this.state,
  });

  final BoardDto? board;
  final BoardPageUsecase boardPageUseCase;
  final BoardPageState state;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        interactive: true,
        timeToFade: const Duration(seconds: 2),
        style: const ScrollbarThemeData(
          scrollbarColor: Colors.white,
          backgroundColor: Colors.transparent,
          thickness: 8,
          hoveringThickness: 8,
        ),
        controller: state.scrollController,
        child: SingleChildScrollView(
          controller: state.scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < (board?.taskListDto?.length ?? 0); i++)
                _ListTasks(
                  item: board?.taskListDto?[i],
                  index: i,
                  boardPageUsecase: boardPageUseCase,
                ),
              Padding(padding: PanelPadding.horizontalItem),
              state.isAddingNewList
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormBoxDefault(
                            controller: state.listTitleController,
                            placeholder: 'Digite o nome da lista...',
                            autoFocus: true,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              OutlinedButtonDefault(
                                title: 'Adicionar lista',
                                onTap: () async {
                                  await state.saveNewTaskList();
                                  await state.getBoardDto();
                                  state.isAddingList();
                                },
                                borderRadius: BorderRadius.circular(4),
                                iconInLeft: true,
                                iconColor: Colors.white,
                                alignment: MainAxisAlignment.start,
                                iconSize: 14,
                                buttonPadding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8,
                                ),
                                textStyle: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 2),
                              ),
                              IconButton(
                                icon: const Icon(
                                  FluentIcons.cancel,
                                  size: 16,
                                  applyTextScaling: true,
                                ),
                                onPressed: () {
                                  state.isAddingList();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      width: 300,
                      child: OutlinedButtonDefault(
                        icon: FluentIcons.add,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        title: 'Adicionar lista',
                        onTap: () {
                          state.isAddingList();
                        },
                        borderRadius: BorderRadius.circular(10),
                        iconInLeft: true,
                        iconColor: Colors.white,
                        alignment: MainAxisAlignment.start,
                        iconSize: 14,
                        buttonPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        textStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideMenu extends StatelessWidget {
  const _SideMenu();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BoardPageState>(context);
    return Container(
      width: 250,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seus quadros',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    FluentIcons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ChangeNotifierProvider.value(
                          value: state, child: const CreateBoardDialog()),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: PanelPadding.verticalItem,
            ),
            for (final item in state.boardsList)
              _BoardItem(
                boardDto: item,
              ),
          ],
        ),
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
    final state = Provider.of<BoardPageState>(context);
    return ContentDialogDefault(
      closeButton: true,
      boxConstraints: const BoxConstraints(
        maxWidth: 400,
      ),
      title: 'Criar quadro',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormBoxDefault(
            header: 'Título do quadro',
            controller: state.boardTitleController,
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

class _BoardItem extends StatelessWidget {
  const _BoardItem({
    required this.boardDto,
  });

  final BoardDto boardDto;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BoardPageState>(context);
    return GestureDetector(
      onTap: () async {
        state.boardId = boardDto.id;
        await state.getBoardDto();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          decoration: BoxDecoration(
            color: state.boardId == boardDto.id
                ? Colors.white.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.blue,
                ),
                width: 25,
                height: 25,
              ),
              Padding(padding: PanelPadding.horizontalItem),
              Text(
                boardDto.title ?? '',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListTasksWidget extends StatelessWidget {
  const _ListTasksWidget({
    required this.item,
    required this.boardPageUsecase,
    required this.listCardLength,
  });

  final TaskListDto? item;
  final BoardPageUsecase boardPageUsecase;
  final int listCardLength;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BoardPageState>(context);
    return Padding(
      padding: PanelPadding.horizontalItem,
      child: DragTarget<TaskDto>(onAccept: (details) {
        state.onDraggedTask(
          details,
          listCardLength,
          0,
        );
      }, builder: (context, candidateData, rejectedData) {
        return Container(
          width: 300,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: candidateData.isEmpty
                ? null
                : Border.all(
                    color: candidateData.isEmpty ? Colors.black : Colors.blue,
                  ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item?.name ?? '',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),
                for (var index = 0;
                    index < (item?.tasksListDto?.length ?? 0);
                    index++) ...[
                  _TaskItemWidget(
                    task: item!.tasksListDto![index],
                    boardPageUsecase: boardPageUsecase,
                    listId: item!.tasksListDto![index].listId ?? 0,
                    listLength: index,
                    listCardLength: listCardLength,
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 6))
                ],
                (item?.isAddingCard ?? false)
                    ? _AddingCardWidget(
                        taskListDto: (item ?? TaskListDto()),
                        reload: () {
                          state.reloadScreen();
                        },
                      )
                    : MouseRegion(
                        onEnter: (event) {
                          state.backgroundAddTaskButton =
                              Colors.black.withOpacity(0.2);
                          item?.backgroundButtonColor =
                              state.backgroundAddTaskButton;
                        },
                        onExit: (event) {
                          state.backgroundAddTaskButton = Colors.transparent;
                          item?.backgroundButtonColor =
                              state.backgroundAddTaskButton;
                        },
                        child: OutlinedButtonDefault.withIcon(
                          title: 'Adicionar um cartão',
                          onTap: () {
                            item?.isAddingCardSetBoolean();
                            state.reloadScreen();
                          },
                          icon: FluentIcons.add,
                          backgroundColor:
                              item?.backgroundButtonColor ?? Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          iconInLeft: true,
                          iconColor: const Color(0xFF44546F),
                          alignment: MainAxisAlignment.start,
                          iconSize: 14,
                          buttonPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          textStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color(0xFF44546F),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _TaskItemWidget extends StatelessWidget {
  const _TaskItemWidget({
    required this.task,
    required this.boardPageUsecase,
    required this.listId,
    required this.listCardLength,
    required this.listLength,
  });

  final TaskDto task;
  final BoardPageUsecase boardPageUsecase;
  final int listId;
  final int listCardLength;
  final int listLength;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BoardPageState>(context);
    return DragTarget<TaskDto>(onAccept: (details) {
      state.onDraggedTask(
        details,
        listCardLength,
        listLength,
      );
    }, builder: (context, candidateData, rejectedData) {
      return Draggable<TaskDto>(
        data: task,
        feedback: Opacity(
          opacity: 0.5,
          child: ChangeNotifierProvider.value(
            value: state,
            child: _TaskContainer(
              task: task,
              boardPageUsecase: boardPageUsecase,
            ),
          ),
        ),
        childWhenDragging: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          width: 300,
          height: 100,
        ),
        child: ChangeNotifierProvider.value(
          value: state,
          child: _TaskContainer(
            task: task,
            boardPageUsecase: boardPageUsecase,
          ),
        ),
      );
    });
  }
}

class _TaskContainer extends StatelessWidget {
  const _TaskContainer({
    required this.task,
    required this.boardPageUsecase,
  });

  final TaskDto task;
  final BoardPageUsecase boardPageUsecase;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BoardPageState>(context);
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => _BuildTaskInformartionsDialog(
            taskDto: task,
            boardPageUsecase: boardPageUsecase,
          ),
        );
        await state.getBoardDto();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Text(task.name ?? ''),
        ),
      ),
    );
  }
}

class _AddingCardWidget extends StatelessWidget {
  const _AddingCardWidget({
    required this.taskListDto,
    required this.reload,
  });

  final TaskListDto taskListDto;
  final Function() reload;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BoardPageState>(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormBoxDefault(
            controller: taskListDto.cardTitleController,
            placeholder: 'Digite o nome do cartão...',
            maxLines: 2,
            maxLength: 100,
            autoFocus: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OutlinedButtonDefault(
                title: 'Adicionar Cartão',
                onTap: () async {
                  await state.saveNewTask(
                    taskListDto.cardTitleController,
                    taskListDto,
                  );
                  taskListDto.isAddingCardSetBoolean();
                  await state.getBoardDto();
                  state.reloadScreen();
                },
                buttonPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
              ),
              Padding(
                padding: PanelPadding.horizontalItem,
              ),
              IconButton(
                icon: const Icon(
                  FluentIcons.cancel,
                  size: 16,
                ),
                onPressed: () {
                  taskListDto.isAddingCardSetBoolean();
                  state.reloadScreen();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListTasks extends StatelessWidget {
  const _ListTasks({
    required this.item,
    required this.index,
    required this.boardPageUsecase,
  });

  final TaskListDto? item;
  final int index;
  final BoardPageUsecase boardPageUsecase;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BoardPageState>(context);
    return DragTarget<TaskListDto>(
      onAccept: (details) async {
        await state.onDraggedList(details, index);
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<TaskListDto>(
          data: item!,
          feedback: Opacity(
            opacity: 0.3,
            child: ChangeNotifierProvider.value(
              value: state,
              child: Transform(
                transform: Matrix4.rotationZ(0.1),
                child: _ListTasksWidget(
                  item: item,
                  boardPageUsecase: boardPageUsecase,
                  listCardLength: index,
                ),
              ),
            ),
          ),
          childWhenDragging: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            width: 300,
            height: 150,
          ),
          child: ChangeNotifierProvider.value(
            value: state,
            child: _ListTasksWidget(
              item: item,
              boardPageUsecase: boardPageUsecase,
              listCardLength: index,
            ),
          ),
        );
      },
    );
  }
}

class _BuildTaskInformartionsDialog extends StatelessWidget {
  final TaskDto taskDto;
  final BoardPageUsecase boardPageUsecase;

  const _BuildTaskInformartionsDialog({
    required this.taskDto,
    required this.boardPageUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TaskModalState(boardPageUseCase: boardPageUsecase, taskDto: taskDto),
      child: Consumer<TaskModalState>(builder: (_, state, __) {
        return ContentDialogDefault(
          actions: [
            OutlinedButtonDefault(
              title: 'Salvar',
              onTap: () async {
                await state.updateTask();
                Navigator.pop(context);
              },
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormBoxDefault(
                controller: state.descriptionTaskController,
                header: 'Descrição',
                maxLines: 3,
                placeholder: 'Adicione uma descrição mais detalhada...',
                autoFocus: true,
              ),
            ],
          ),
          title: taskDto.name ?? '',
        );
      }),
    );
  }
}
