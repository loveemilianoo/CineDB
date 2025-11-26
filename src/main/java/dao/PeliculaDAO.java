package dao;

import entity.*;
import conexion.Conexion;
import java.sql.*;
import java.time.Duration;
import java.util.*;

public class PeliculaDAO {
    public void insetrtarPelicula(Pelicula pelicula){
        Connection conn = null;
        Conexion conexion = new Conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try{
            conn = conexion.getConexion();
            String query = "INSERT INTO tablas.pelicula (titulo, duracion, genero, clasificacion) VALUES (?,?,?,?)";
            ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            
            String duracionPostgres = formatDurationToPostgres(pelicula.getDuracion());
            
            ps.setString(1, pelicula.getTitulo());
            ps.setString(2, duracionPostgres);
            ps.setString(3, pelicula.getGenero());
            ps.setString(4, pelicula.getClasificacion());
            
            int filas = ps.executeUpdate();
            if (filas > 0){
                rs = ps.getGeneratedKeys();
                if (rs.next()){
                    int idPelicula = rs.getInt(1);
                    pelicula.setIdPelicula(idPelicula);
                    System.out.println("Pelicula Insertada!!");
                }
            }
            
        } catch (SQLException e){
            System.out.println("Error "+e.toString());
            e.printStackTrace();
        } finally {
            try{
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e){
                System.out.println("Error en la base de datos "+e.toString());
                e.printStackTrace();
            }
        }
    }
    
    private String formatDurationToPostgres(Duration duration) {
        long hours = duration.toHours();
        long minutes = duration.toMinutesPart();
        long seconds = duration.toSecondsPart();
        
        return String.format("%02d:%02d:%02d", hours, minutes, seconds);
    }
    
    public List <Pelicula> getPeliculas (){
        List <Pelicula> peliculas = new ArrayList();
        Connection conn = null;
        Conexion conexion = new Conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try{
            conn = conexion.getConexion();
            String query = "SELECT * FROM tablas.pelicula";
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnas = rsmd.getColumnCount();
            while (rs.next()){
                String duracionStr = rs.getString("duracion");
                
                Pelicula pelicula = new Pelicula();
                pelicula.setIdPelicula(rs.getInt("id_pelicula"));
                pelicula.setTitulo(rs.getString("titulo"));
                pelicula.setDuracion(parseDurationFromPostgres(duracionStr));
                pelicula.setGenero(rs.getString("genero"));
                pelicula.setClasificacion(rs.getString("clasificacion"));
            
                peliculas.add(pelicula);
            }
        } catch (Exception e){
            System.out.println("Error "+e.toString());
            e.printStackTrace();
        } finally {
             try {
                 if (rs!= null) rs.close();
                 if (ps!= null) ps.close();
                 if (conn != null) conn.close();
             } catch (SQLException e){
                 System.out.println("Error al cerrar recursos "+e.toString());
             }
         } 
         return peliculas;
     }
    
    public Duration parseDurationFromPostgres (String intervalo){
        String [] partes = intervalo.split(":");
        long horas = Long.parseLong(partes[0]);
        long minutos = Long.parseLong(partes[1]);
        long segundos = partes.length > 2? Long.parseLong(partes[2]) :0 ;
        return Duration.ofHours(horas).plusMinutes(minutos).plusSeconds(segundos);
    }
}
