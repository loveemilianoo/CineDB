package dao;

import conexion.Conexion;
import entity.*;
import java.sql.*;
import java.time.Duration;
import java.util.*;

public class FuncionDAO {
    public List<Funcion> getFuncionesPelicula(int idPelicula) {
        List<Funcion> funciones = new ArrayList<>();
        Connection conn = null;
        Conexion conexion = new Conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = conexion.getConexion();

            String queryIdPelicula = """
                    SELECT f.*, p.titulo as pelicula_titulo, s.numero_sala, s.capacidad
                    FROM tablas.funcion f
                    JOIN tablas.pelicula p
                    ON f.id_pelicula = p.id_pelicula
                    JOIN tablas.sala s ON f.id_sala = s.id_sala
                    WHERE f.id_pelicula = ? AND f.fecha >= CURRENT_DATE
                    ORDER BY f.fecha, f.hora_inicio""";
            ps = conn.prepareStatement(queryIdPelicula);
            ps.setInt(1, idPelicula);
            rs = ps.executeQuery();

            while (rs.next()) {
                Funcion funcion = new Funcion();
                funcion.setIdFuncion(rs.getInt("id_funcion"));
                funcion.setIdPelicula(rs.getInt("id_pelicula"));
                funcion.setIdSala(rs.getInt("id_sala"));
                funcion.setHoraInicio(duracionPostgres(rs.getString("hora_inicio")));
                funcion.setFecha(rs.getDate("fecha").toLocalDate());
                funciones.add(funcion);
            }
        } catch (Exception e) {
            System.out.println("Error " + e.toString());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (ps != null)
                    ps.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return funciones;
    }

    public List<Funcion> getFunciones() {
        List<Funcion> funciones = new ArrayList<>();
        Connection conn = null;
        Conexion conexion = new Conexion();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = conexion.getConexion();

            String query = """
                        SELECT f.*, p.titulo as pelicula_titulo, s.numero_sala
                    FROM tablas.funcion f
                    JOIN tablas.pelicula p ON f.id_pelicula = p.id_pelicula
                    JOIN tablas.sala s ON f.id_sala = s.id_sala
                    ORDER BY f.fecha DESC, f.hora_inicio
                        """;
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Funcion funcion = new Funcion();
                funcion.setIdFuncion(rs.getInt("id_funcion"));
                funcion.setIdPelicula(rs.getInt("id_pelicula"));
                funcion.setIdSala(rs.getInt("id_sala"));
                funcion.setHoraInicio(duracionPostgres(rs.getString("hora_inicio")));
                funcion.setFecha(rs.getDate("fecha").toLocalDate());
                funciones.add(funcion);
            }
        } catch (Exception e) {
            System.out.println("Error " + e.toString());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (ps != null)
                    ps.close();
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar recursos " + e.toString());
            }
        }
        return funciones;
    }

    private Duration duracionPostgres(String intervalo) {
        try {
            long horas, minutos, segundos;
            String[] partes = intervalo.split(":");
            horas = Long.parseLong(partes[0]);
            minutos = Long.parseLong(partes[1]);
            segundos = partes.length > 2 ? Long.parseLong(partes[2]) : 0;
            return Duration.ofHours(horas).plusMinutes(minutos).plusSeconds(segundos);
        } catch (Exception e) {
            return Duration.ofHours(1);
        }
    }

}
