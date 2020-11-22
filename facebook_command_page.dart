import 'dart:html';

import 'package:fbpro_api/fbpro_api.dart';
import 'package:fbpro_web/models/notify_message.dart';

import 'package:fbpro_web/pages/client_node/list/client_node_bloc.dart';
import 'package:fbpro_web/pages/client_node/list/client_node_event.dart';
import 'package:fbpro_web/pages/client_node/list/client_node_state.dart';
import 'package:fbpro_web/pages/facebook_account/list/facebook_account_page.dart';
import 'package:fbpro_web/pages/facebook_tasks/facebook_task_helper.dart';
import 'package:fbpro_web/services/notify_service/notify_service.dart';
import 'package:fbpro_web/widgets/data_row_action_button.dart';

import 'package:fbpro_web/widgets/load_list_error.dart';
import 'package:fbpro_web/widgets/widget_for_bloc/bloc_loading_screen.dart';
import 'package:fbpro_web/widgets/widget_for_bloc/bloc_ui_provider.dart';
import 'package:fbpro_web/widgets/widget_for_list/app_data_table.dart';
import 'package:fbpro_web/widgets/widget_for_list/list_page_app_bar.dart';
import 'package:fbpro_web/widgets/widget_for_list/list_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fbpro_web/extensions/extension.dart';
import 'package:overlay_container/overlay_container.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tmt_flutter_ui/tmt_flutter_ui.dart';

import '../../locator.dart';
import 'facebook_command_bloc.dart';
import 'facebook_command_event.dart';
import 'facebook_command_state.dart';

class FacebookCommandsPage extends StatefulWidget {
  const FacebookCommandsPage({Key key, this.facebookAccount, this.campaignId})
      : super(key: key);
  final FacebookAccount facebookAccount;
  final int campaignId;

  @override
  _FacebookCommandsPageState createState() => _FacebookCommandsPageState();
}

class _FacebookCommandsPageState extends State<FacebookCommandsPage> {
  final FacebookCommandsBloc _bloc = FacebookCommandsBloc();
  final ClientNodesBloc _clientNodesBloc = ClientNodesBloc();
  final TextEditingController _keywordController = TextEditingController();

  final int _rowsPerPage = 200;
  int _currentPage = 0;

  int get _offset => _currentPage * _rowsPerPage;
  List<String> typeFacebooks = [];
  List<FacebookCommandStatus> states = [];

  double heightBoxStatus = 0;

  List<bool> selects = [false, false];

  final NotifyService _notify = locator<NotifyService>();

  // ignore: always_specify_types
  final BehaviorSubject _searchController = BehaviorSubject();
  ClientNode _clientNode;
  FacebookAccount _facebookAccount;
  String typeSelected;
  int _facebookAccountId;
  int _campaignId;
  FacebookCommandType _type;
  FacebookCommandStatus _status;
  String _keyWord;
  DateTime _actionDateFrom;
  DateTime _actionDateTo;
  DateTime _dateCreatedFrom;
  DateTime _dateCreatedTo;
  bool isShowType = false;
  bool isIdle = false;
  List<bool> isStateFacebooks = [];

  GetFacebookCommandsQuery getQuery(String keyWord) {
    final List<FacebookCommandStatus> stateSelects = <FacebookCommandStatus>[];
    _keyWord = keyWord;
    for(int i =0; i< isStateFacebooks.length; i++){
      if(isStateFacebooks[i]){
        stateSelects.add(states[i]);
      }
    }
    return GetFacebookCommandsQuery(
      keyword: _keyWord != null ? _keyWord.trim() : '',
      offset: _offset,
      limit: _rowsPerPage,
      clientNodeId: _clientNode?.id,
      facebookAccountId: _facebookAccountId ?? _facebookAccount?.id,
      type: _type,
      status: stateSelects,
      dateCreatedFrom: _dateCreatedFrom,
      dateCreatedTo: _dateCreatedTo,
      actionTimeFrom: _actionDateFrom,
      actionTimeTo: _actionDateTo,
      campaignId: _campaignId,
    );
  }

  void _handleOnRowPerPageChanged(value) {}

  void _handleRefresh({String keyWord}) {
    _bloc.add(
      FacebookCommandsRefreshed(query: getQuery(keyWord)),
    );
  }

  Future<void> _handleAdd(BuildContext context, {String faceBookPostId}) async {
    await showAddDeviceTaskSelect(context, facebookAccount: _facebookAccount,
        onRefresh: () {
      _handleRefresh();
    }, faceBookPostId: faceBookPostId);
  }

  Future<void> _handleEdit(BuildContext context,
      {String faceBookPostId, String type}) async {
    await showEditDeviceTask(context, facebookAccount: _facebookAccount,
        onRefresh: () {
      _handleRefresh();
    }, faceBookPostId: faceBookPostId, type: type);
  }

  @override
  void initState() {
    states = getFacebookCommandStatuss();
    for(int i =0; i<states.length; i++){
      isStateFacebooks.add(false);
    }
    if (widget.facebookAccount != null) {
      _facebookAccount = widget.facebookAccount;
    }
    _searchController
        .debounceTime(const Duration(milliseconds: 400))
        .listen((event) {
      _handleRefresh(keyWord: event);
    });

    _campaignId = widget.campaignId;
    _clientNodesBloc.add(ClientNodesLoaded());
    typeFacebooks = getTypeFacebooks();
    _bloc.add(
      FacebookCommandsLoaded(
        query: getQuery(''),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<FacebookCommandsBloc>(
      listen: (state) {
        if (state is FacebookCommandsActionSuccess) {
          _notify.showNotify(
              NotifyMessage(title: state.title, message: state.message));
          _handleRefresh();
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
      busyStates: const [FacebookCommandsLoading],
      bloc: _bloc,
    );
  }

  Widget _buildAppBar() => ListPageAppbar(
        onKeywordChanged: (String value) {
          _searchController.add(value);
        },
        title: ' Nhiệm vụ & Công việc',
        onRefreshPressed: _handleRefresh,
        onAddPressed: () => _handleAdd(context),
      );

  Widget _buildFilter() {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildFilterByClientNode(),
          const SizedBox(
            width: 10,
          ),
          _buildFilterByFacebookAccount(),
          _buildTypes(),
          // _buildPrivacySelectButton(),
          InkWell(
              onTap: () {
                setState(() {
                  isShowType = !isShowType;
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200,),
                      borderRadius: BorderRadius.circular(5)),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 50,
                  child: Center(child:  Text('State (+)')))),
          const SizedBox(
            width: 10,
          ),
          StatefulBuilder(builder: (context, state) {
            return OverlayContainer(
              show: isShowType,
              // Let's position this overlay to the right of the button.
              position: const OverlayContainerPosition(
                // Left position.
                -280,
                // Bottom position.
                -20,
              ),
              // The content inside the overlay.
              child: Container(
                  height: 300,
                  width: 200,
                  padding: const EdgeInsets.only(
                      left: 6, top: 12, right: 12, bottom: 12),
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 2,
                          offset: const Offset(-1, 1))
                    ],
                  ),
                  child: Column(
                      children: [
                        ...List.generate(states.length, (int index) => FlatButton(
                          onPressed: () {
                            setState(() {
                              isStateFacebooks[index] = !isStateFacebooks[index];
                            });
                            _handleRefresh();
                          },
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              _buildCheckBox(isStateFacebooks[index]),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                    color: Colors.green, shape: BoxShape.circle),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                               Text(states[index].describe)
                            ],
                          ),
                        )),
                        const SizedBox(height: 4,),
                        Container(height: 1,width: double.infinity,color: Colors.grey[300],),
                        const SizedBox(height: 4,),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: (){
                              setState(() {
                                for(int i =  0 ;i < isStateFacebooks.length; i++){
                                  isStateFacebooks[i] = false;
                                }
                              });
                            },
                            child: Row(mainAxisSize: MainAxisSize.min,children: const[
                              Icon(Icons.close,size: 18,),
                               SizedBox(width: 12,),
                              Text('Clear')
                            ],),
                          ),
                        )
                      ],
                    ),
                  ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPrivacySelectButton() {
    return PopupMenuButton<dynamic>(
      child: PopupMenuButtonContent(
        title: const Text('Status()'),
        icon: const Icon(Icons.star_border),
        onPressed: () {},
      ),
      onCanceled: () {
        print('cacel');
      },
      onSelected: (value) {
        print('value');
        setState(() {
          // _statusPrivacyType = value;
        });
      },
      enabled: true,
      itemBuilder: (BuildContext context) {
        return [];
      },
    );
  }

  // Widget _buildPopup(){
  //   return s
  // }

  Widget _buildTypes() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          )),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(left: 8),
      width: 220,
      child: DropdownButton(
          underline: const SizedBox(),
          hint: const Text('Lọc theo loại'),
          isExpanded: true,
          value: typeSelected,
          onChanged: (value) {
            setState(() {
              typeSelected = value;
            });
            _type = getTypeByKey(value);
            _handleRefresh();
          },
          items: typeFacebooks
              .map((String e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList()),
    );
  }

  Widget _buildDateFromButton() {
    return FlatButton.icon(
      icon: Icon(
        Icons.date_range,
        color: Colors.grey[700],
        size: 20,
      ),
      label: Text(_actionDateFrom == null
          ? '< Ngày /Tháng/ Năm>'
          : _actionDateFrom.toStringFormat('dd/MM/yyyy HH:ss')),
      onPressed: () async {
        final DateTime selectedDate = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          currentDate: _actionDateFrom ?? DateTime.now(),
          lastDate: DateTime.now().add(
            const Duration(days: 99),
          ),
          initialDate: _actionDateFrom ?? DateTime.now(),
        );

        if (selectedDate != null) {
          final TimeOfDay selectedTime = await showTimePicker(
            initialTime: TimeOfDay.fromDateTime(selectedDate),
            context: context,
          );

          if (selectedTime != null) {
            setState(() {
              final DateTime timeSelect = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute);
              _actionDateFrom = timeSelect;
            });
          }
          // if (selectedDate != null) {
          //   setState(() {
          //     _actionDateFrom = selectedDate;
          //   });
          // }
        }
      },
    );
  }

  Widget _buildFilterByClientNode() {
    return StatefulBuilder(
      builder: (BuildContext context, setState) => Container(
        child: BlocBuilder<ClientNodesBloc, ClientNodesState>(
          cubit: _clientNodesBloc,
          builder: (BuildContext context, ClientNodesState state) {
            if (state is ClientNodesLoadSuccess) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    )),
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.only(left: 8),
                width: 200,
                // ignore: always_specify_types
                child: DropdownButton(
                  underline: const SizedBox(),
                  hint: const Text('Lọc theo PC'),
                  isExpanded: true,
                  value: state.items.firstWhere(
                      (ClientNode element) => element.id == _clientNode?.id,
                      orElse: () => null),
                  onChanged: (value) {
                    setState(() {
                      _clientNode = value;
                    });

                    _handleRefresh();
                  },
                  items: state.items
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name ?? ''),
                          ))
                      .toList(),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildFilterByFacebookAccount() {
    return InkWell(
      onTap: () async {
        final account = await Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) {
              return const FacebookAccountPage(
                onlyActive: true,
                selectMode: true,
              );
            },
          ),
        );

        if (account != null) {
          setState(() {
            _facebookAccount = account;
          });
          _handleRefresh();
        }
      },
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
              child: Text(
            _facebookAccount != null
                ? _facebookAccount.name
                : '<Chọn tài khoản>',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          Visibility(
            visible: _facebookAccount != null,
            child: InkWell(
                onTap: () {
                  setState(() {
                    _facebookAccount = null;
                  });
                  _handleRefresh(keyWord: '');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 20,
                  height: 20,
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.red,
                  ),
                )),
          ),
          const Icon(Icons.keyboard_arrow_down)
        ]),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildFilter(),
        Expanded(
          child: BlocLoadingScreen<FacebookCommandsBloc>(
            busyStates: const [FacebookCommandsRefreshing],
            isModal: false,
            child: BlocBuilder<FacebookCommandsBloc, FacebookCommandsState>(
                buildWhen: (a, b) => b is FacebookCommandsLoadSuccess,
                builder: (context, state) {
                  if (state is FacebookCommandsLoadSuccess) {
                    return AppDataTable(
                      columns: const [
                        DataColumn(label: Text("Thao tác")),
                        DataColumn(label: Text("Máy tính")),
                        DataColumn(label: Text("Người dùng")),
                        DataColumn(label: Text('Nhiệm vụ')),
                        DataColumn(label: Text('Loại')),
                        DataColumn(label: Text('Thời gian')),
                        DataColumn(label: Text('Trạng thái')),
                      ],
                      builder: (BuildContext context, int index) =>
                          _buildDataRow(state.items[index], index),
                      itemCount: state.items.length,
                      footer: ListPagination(
                        initPage: _currentPage,
                        itemCount: state.totalCount,
                        rowPerPage: _rowsPerPage,
                        onRowsPerPageChanged: _handleOnRowPerPageChanged,
                        onPageChanged: (int page) {
                          _currentPage = page;
                          _handleRefresh();
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                }),
          ),
        ),
      ],
    );
  }

  DataRow _buildDataRow(PostStatusToNewFeedTask command, int index) {
    const TextStyle style = TextStyle(color: Colors.black);
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Row(
          children: [
            DataRowActionButton(
              icon: const Icon(
                Icons.edit,
                size: 15,
              ),
              onPressed: () {
                _handleEdit(context,
                    faceBookPostId: command.id, type: command.type);
              },
            ),
            const SizedBox(
              width: 12,
            ),
            DataRowActionButton(
              icon: const Icon(
                Icons.delete_forever,
                size: 15,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          )),
                      title: const Text(
                        "Xác nhận xóa",
                        style: TextStyle(color: Colors.green, fontSize: 18),
                      ),
                      content: Text('Bạn có chắc muốn xóa?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Không'),
                          onPressed: () {
                            Navigator.of(context)?.pop();
                          },
                        ),
                        FlatButton(
                          child: Text('Có'),
                          onPressed: () {
                            Navigator.of(context)?.pop();
                            _bloc.add(FacebookCommandsDeleted(item: command));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        )),
        DataCell(Text(
          command.clientNodeName ?? '',
          style: style,
        )),
        DataCell(Text(
          command.facebookName ?? '',
          style: style,
        )),
        DataCell(Text(
          command.taskName ?? '',
          style: style,
        )),
        DataCell(Text(command.type ?? '', style: style)),
        DataCell(Text(
            command.actionTime == null
                ? ''
                : command.actionTime
                    .toLocal()
                    .toStringFormat('dd/MM/yyyy HH:mm'),
            style: style)),
        DataCell(Text(
          command.status ?? '',
          style: style,
        )),
      ],
    );
  }

  Widget _buildCheckBox([bool isCheck = false]) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
          color: isCheck ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey)),
      child: const Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 13,
        ),
      ),
    );
  }
}
