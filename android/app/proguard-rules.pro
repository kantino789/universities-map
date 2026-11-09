# Keep WorkManager database implementation and constructors from being stripped by R8
-keep class androidx.work.impl.WorkDatabase { *; }
-keep class * extends androidx.room.RoomDatabase {
    <init>();
}
-keep class androidx.work.impl.* { *; }