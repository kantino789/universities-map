import 'package:universities_map/model/subjects_lists.dart';

Map<String, Iterable<String>> subjectsGroupsMap = {
  'Natural Sciences': naturalSciencesSubjects,
  'Engineering': engineeringSubjects,
  'Life Sciences': lifeSciencesSubjects,
  'Medical Sciences': medicalSciencesSubjects,
  'Social Sciences': socialSciencesSubjects,
};

final Map<String, String> subjectToGroup = {
  for (final group in subjectsGroupsMap.entries)
    for (final subject in group.value) subject: group.key,
};
