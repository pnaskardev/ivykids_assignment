import 'package:flutter/material.dart';
import 'package:ivykids_assignment/features/home/widgets/contact_card.dart';
import 'package:ivykids_assignment/features/home/widgets/widgets.dart';
import 'package:ivykids_assignment/model/contact.dart';
import 'package:ivykids_assignment/providers/user_provider.dart';
import 'package:ivykids_assignment/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          centerTitle: true,
        ),
        body: Center(
          child: Consumer<UserProvider>(
            builder: (context, data, child) {
              return data.user.contacts.isEmpty
                  ? const Center(
                      child: Text('There are no contacts'),
                    )
                  : ListView.builder(
                      itemCount: data.user.contacts.length,
                      itemBuilder: (context, index) {
                        return ContactCard(
                          name: data.user.contacts[index].name!,
                          email: data.user.contacts[index].email!,
                          phone: data.user.contacts[index].phone!,
                          onEdit: () async
                          {
                            try 
                            {
                              showModalSheet(context, FormWidget(contact: Contacts
                                (
                                  name: data.user.contacts[index].name!,
                                  email: data.user.contacts[index].email!,
                                  phone: data.user.contacts[index].phone!,
                                ), 
                                onSave: (Contacts contact) async
                                {
                                    Provider.of<UserProvider>(context,
                                      listen: false)
                                  .setLoading(true);
                                  await Provider.of<UserProvider>(context,
                                      listen: false)
                                  .updateContact(data.user.id,
                                      data.user.contacts[index].id!,contact.name!,contact.email!,contact.phone!,context);
                                  Provider.of<UserProvider>(context,
                                      listen: false)
                                  .setLoading(false);
                                },));
                             
                            } catch (e) 
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          onDelete: () async {
                            try {
                              Provider.of<UserProvider>(context,
                                      listen: false)
                                  .setLoading(true);
                        
                              // showAlertDialog(context);
                              await Provider.of<UserProvider>(context,
                                      listen: false)
                                  .deleteContact(data.user.id,
                                      data.user.contacts[index].id!, context);
                              Provider.of<UserProvider>(context,
                                      listen: false)
                                  .setLoading(false);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                        );
                      },
                    );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalSheet(context,  FormWidget
              (
                onSave: (Contacts contact) async
                {
                    Provider.of<UserProvider>(context,
                      listen: false)
                  .setLoading(true);
                  await Provider.of<UserProvider>(context,
                      listen: false)
                  .addContact
                  (
                    contact.name!,
                    contact.phone!, 
                    contact.email!, 
                    Provider.of<UserProvider>(context,listen: false).user.id,
                    context
                  );
                  Provider.of<UserProvider>(context,
                      listen: false)
                  .setLoading(false);
                }
              ));
            },
            label: const Text('Add Contact')),
      ),
    );
  }
}
