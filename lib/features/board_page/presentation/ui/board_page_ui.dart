import 'package:fluent_ui/fluent_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/style/panel_padding.dart';
import '../../../../utils/content_dialog_default.dart';
import '../../../../utils/outlined_button_default.dart';
import '../../../../utils/text_form_box_default.dart';
import '../../../home_page/presentation/ui/home_page_ui.dart';
import '../../layers/data/dto/task_dto.dart';
import '../../layers/data/dto/task_list_dto.dart';
import '../../layers/domain/entities/task_list_entity.dart';
import '../../layers/domain/usecases/board_page_usecase.dart';
import '../states/board_page_state.dart';
import '../states/task_modal_state.dart';

/// Widget to build a board page UI
class BoardPageUi extends StatelessWidget {
  /// Board id
  final int boardId;

  /// Constructor
  const BoardPageUi({
    super.key,
    required this.boardId,
  });

  @override
  Widget build(BuildContext context) {
    final boardPageUseCase = GetIt.instance.get<BoardPageUsecase>();

    return ChangeNotifierProvider(
      create: (context) => BoardPageState(
        boardId: boardId,
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
                  PageHeaderDefault(
                    customTitle: board?.title,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0;
                                i < (board?.taskListDto?.length ?? 0);
                                i++)
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
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormBoxDefault(
                                          controller: state.listTitleController,
                                          placeholder:
                                              'Digite o nome da lista...',
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 2),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            OutlinedButtonDefault(
                                              title: 'Adicionar Lista',
                                              onTap: () async {
                                                await state.saveNewTaskList();
                                                await state.getBoardDto();
                                                state.isAddingList();
                                              },
                                              buttonPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  PanelPadding.horizontalItem,
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                FluentIcons.cancel,
                                                size: 16,
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
                                      alignment: MainAxisAlignment.start,
                                      iconInLeft: true,
                                      iconColor: Colors.black,
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.1),
                                      title: 'Adicionar lista',
                                      onTap: () {
                                        state.isAddingList();
                                      },
                                      fontColor: Colors.black,
                                      buttonPadding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 20,
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}

class _ListTasksWidget extends StatelessWidget {
  const _ListTasksWidget({
    required this.item,
    required this.boardPageUsecase,
  });

  final TaskListDto? item;
  final BoardPageUsecase boardPageUsecase;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BoardPageState>(context);
    return Padding(
      padding: PanelPadding.horizontalItem,
      child: Container(
        key: item?.globalKey,
        width: 300,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(padding: PanelPadding.verticalItem),
              for (final task in (item?.tasksListDto ?? <TaskDto>[])) ...[
                _TaskItemWidget(
                  task: task,
                  boardPageUsecase: boardPageUsecase,
                  listId: task.listId ?? 0,
                ),
                const Padding(padding: EdgeInsets.only(bottom: 4))
              ],
              (item?.isAddingCard ?? false)
                  ? _AddingCardWidget(
                      taskListDto: (item ?? TaskListDto()),
                      reload: () {
                        state.reloadScreen();
                      },
                    )
                  : OutlinedButtonDefault.withIcon(
                      title: 'Adicionar cartão',
                      onTap: () {
                        item?.isAddingCardSetBoolean();
                        state.reloadScreen();
                      },
                      icon: FluentIcons.add,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskItemWidget extends StatelessWidget {
  const _TaskItemWidget({
    required this.task,
    required this.boardPageUsecase,
    required this.listId,
  });

  final TaskDto task;
  final BoardPageUsecase boardPageUsecase;
  final int listId;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<BoardPageState>(context);
    return DragTarget<TaskDto>(onAccept: (details) {
      final sourceList = state.boardDto?.taskListDto!
          .firstWhere((list) => list.tasksListDto!.contains(details));

      final targetList =
          state.boardDto?.taskListDto?.firstWhere((list) => list.id == listId);

      final newPosition = state.calculateNewPosition(details, targetList);

      state.onDraggedTask(
        details,
        (sourceList ?? TaskListDto()),
        (targetList ?? TaskListDto()),
        newPosition,
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
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey.withOpacity(0.1)),
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
    return DragTarget<TaskListEntity>(
      onAccept: (details) async {
        await state.onDraggedList(details, index);
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<TaskListEntity>(
          data: item!,
          feedback: Opacity(
            opacity: 0.5,
            child: ChangeNotifierProvider.value(
              value: state,
              child: _ListTasksWidget(
                item: item,
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
            height: 150,
          ),
          child: ChangeNotifierProvider.value(
            value: state,
            child: _ListTasksWidget(
              item: item,
              boardPageUsecase: boardPageUsecase,
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
              ),
            ],
          ),
          title: taskDto.name ?? '',
        );
      }),
    );
  }
}
